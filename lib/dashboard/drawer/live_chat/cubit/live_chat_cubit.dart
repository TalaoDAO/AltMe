import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matrix/matrix.dart' hide User;
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'live_chat_cubit.g.dart';
part 'live_chat_state.dart';

class LiveChatCubit extends Cubit<LiveChatState> {
  LiveChatCubit({
    required this.didKit,
    required this.secureStorageProvider,
    required this.dioClient,
  }) : super(
          const LiveChatState(),
        ) {
    init();
  }

  final SecureStorageProvider secureStorageProvider;
  Client? client;
  final DioClient dioClient;
  final logger = getLogger('LiveChatCubit');
  String? _roomId;
  final DIDKitProvider didKit;
  StreamSubscription<Event>? _onEventSubscription;
  StreamController<int>? _notificationStreamController;

  Stream<int> get unreadMessageCountStream {
    _notificationStreamController ??= StreamController<int>.broadcast();
    return _notificationStreamController!.stream;
  }

  Future<void> onSendPressed(PartialText partialText) async {
    try {
      final messageId = const Uuid().v4();
      final message = TextMessage(
        author: state.user!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: messageId,
        text: partialText.text,
        status: Status.sending,
      );
      emit(state.copyWith(messages: [message, ...state.messages]));
      //
      await _checkIfRoomNotExistThenCreateIt();
      final room = client!.getRoomById(_roomId!);
      if (room == null) {
        await client!.joinRoomById(_roomId!);
      }
      final eventId = await client!.getRoomById(_roomId!)?.sendTextEvent(
            partialText.text,
            txid: messageId,
          );
      logger.i('send text event: $eventId');
    } catch (e, s) {
      logger.e('e: $e , s: $s');
    }
  }

  Future<void> handleMessageTap(Message message) async {
    if (message is FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              state.messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (state.messages[index] as FileMessage).copyWith(
            isLoading: true,
          );

          state.messages[index] = updatedMessage;
          emit(state.copyWith(messages: state.messages));

          final httpClient = http.Client();
          final request = await httpClient.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              state.messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (state.messages[index] as FileMessage).copyWith(
            isLoading: null,
          );

          state.messages[index] = updatedMessage;
          emit(state.copyWith(messages: state.messages));
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void handlePreviewDataFetched(
    TextMessage message,
    PreviewData previewData,
  ) {
    final index = state.messages.indexWhere(
      (element) => element.id == message.id,
    );
    final updatedMessage = (state.messages[index] as TextMessage).copyWith(
      previewData: previewData,
    );
    state.messages[index] = updatedMessage;
    emit(state.copyWith(messages: state.messages));
  }

  Future<void> handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final messageId = const Uuid().v4();
      final message = FileMessage(
        author: state.user!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: messageId,
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
        status: Status.sending,
      );
      emit(state.copyWith(messages: [message, ...state.messages]));
      await _checkIfRoomNotExistThenCreateIt();
      await client!.getRoomById(_roomId!)?.sendFileEvent(
            MatrixFile(
              bytes: File(result.files.single.path!).readAsBytesSync(),
              name: result.files.single.name,
            ),
            txid: messageId,
          );
    }
  }

  Future<void> handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final messageId = const Uuid().v4();

      final message = ImageMessage(
        author: state.user!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: messageId,
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
        status: Status.sending,
      );

      emit(state.copyWith(messages: [message, ...state.messages]));

      await _checkIfRoomNotExistThenCreateIt();
      await client!.getRoomById(_roomId!)?.sendFileEvent(
            MatrixFile(
              bytes: bytes,
              name: result.name,
            ),
            txid: messageId,
          );
    }
  }

  Future<void> init() async {
    logger.i('init()');
    try {
      final ssiKey = await secureStorageProvider.get(SecureStorageKeys.ssiKey);
      final did = await secureStorageProvider.get(SecureStorageKeys.did) ?? '';
      final username = did.replaceAll(':', '-');
      if (ssiKey == null || ssiKey.isEmpty || did.isEmpty || username.isEmpty) {
        emit(
          state.copyWith(
            status: AppStatus.error,
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
        return;
      }

      emit(state.copyWith(status: AppStatus.loading));
      await _initClient();
      final isUserRegisteredMatrix = await secureStorageProvider
          .get(SecureStorageKeys.isUserRegisteredMatrix);
      late String userId;
      if (isUserRegisteredMatrix != 'true') {
        await _register(did: did);
        await secureStorageProvider.set(
          SecureStorageKeys.isUserRegisteredMatrix,
          true.toString(),
        );
        userId = await _login(
          username: username,
          password: await _getPasswordForDID(),
        );
      } else {
        userId = await _login(
          username: username,
          password: await _getPasswordForDID(),
        );
      }
      List<Message> retrivedMessageFromDB = [];
      final savedRoomId = await _getRoomIdFromStorage();
      if (savedRoomId != null) {
        _roomId = savedRoomId;
        await _enableRoomEncyption(savedRoomId);
        _getUnreadMessageCount();
        await _subscribeToEventsOfRoom();
        retrivedMessageFromDB = await _retriveMessagesFromDB(_roomId!);
      }
      logger.i('roomId : $_roomId');
      emit(
        state.copyWith(
          status: AppStatus.init,
          user: User(id: userId),
          messages: retrivedMessageFromDB,
        ),
      );
    } catch (e, s) {
      logger.e('error: $e, stack: $s');
      if (e is MatrixException) {
        emit(
          state.copyWith(
            status: AppStatus.error,
            message: StateMessage.error(
              stringMessage: e.errorMessage,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppStatus.error,
            message: StateMessage(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _subscribeToEventsOfRoom() async {
    await _onEventSubscription?.cancel();

    _onEventSubscription = client!.onRoomState.stream.listen((Event event) {
      if (event.roomId == _roomId && event.type == 'm.room.message') {
        final txId = event.unsigned?['transaction_id'] as String?;
        if (state.messages.any(
          (element) => element.id == txId,
        )) {
          final index = state.messages.indexWhere(
            (element) => element.id == txId,
          );
          final updatedMessage = state.messages[index].copyWith(
            status: _mapEventStatusToMessageStatus(event.status),
          );
          final newMessages = List.of(state.messages);
          newMessages[index] = updatedMessage;
          emit(state.copyWith(messages: newMessages));
        } else {
          final Message message = _mapEventToMessage(event);
          _getUnreadMessageCount();
          emit(
            state.copyWith(
              messages: [message, ...state.messages],
            ),
          );
        }
      }
    });
  }

  Message _mapEventToMessage(Event event) {
    late final Message message;
    if (event.messageType == 'm.text') {
      message = TextMessage(
        id: event.unsigned?['transaction_id'] as String? ?? const Uuid().v4(),
        remoteId: event.eventId,
        text: event.text,
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        status: _mapEventStatusToMessageStatus(event.status),
        author: User(
          id: event.senderId,
        ),
      );
    } else if (event.messageType == 'm.image') {
      message = ImageMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        name: event.body,
        size: event.content['info']['size'] as num,
        uri: _getUrlFromUri(event.content['url'] as String),
        status: _mapEventStatusToMessageStatus(event.status),
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        author: User(
          id: event.senderId,
        ),
      );
    } else if (event.messageType == 'm.file') {
      message = FileMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        name: event.body,
        size: event.content['info']['size'] as num,
        uri: _getUrlFromUri(event.content['url'] as String),
        status: _mapEventStatusToMessageStatus(event.status),
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        author: User(
          id: event.senderId,
        ),
      );
    } else if (event.messageType == 'm.audio') {
      message = AudioMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        duration: Duration(
          milliseconds: event.content['info']['duration'] as int,
        ),
        name: event.body,
        size: event.content['info']['size'] as num,
        uri: _getUrlFromUri(event.content['url'] as String),
        status: _mapEventStatusToMessageStatus(event.status),
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        author: User(
          id: event.senderId,
        ),
      );
    } else {
      message = TextMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        text: event.text,
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        status: _mapEventStatusToMessageStatus(event.status),
        author: User(
          id: event.senderId,
        ),
      );
    }
    return message;
  }

  int get unreadMessageCount =>
      client?.getRoomById(_roomId ?? '')?.notificationCount ?? 0;

  void _getUnreadMessageCount() {
    final unreadCount = unreadMessageCount;
    logger.i('unread message count: $unreadCount');
    _notificationStreamController?.sink.add(unreadCount);
  }

  Future<void> markMessageAsRead(List<String?>? eventIds) async {
    if (eventIds == null || eventIds.isEmpty) return;

    final room = client?.getRoomById(_roomId ?? '');
    if (room == null) return;
    try {
      for (final eventId in eventIds) {
        if (eventId != null) {
          await room.postReceipt(eventId);
        }
      }
    } catch (e, s) {
      logger.e('e: $e , s: $s');
    }
    _getUnreadMessageCount();
  }

  // this function called when state emited in UI and needs
  // to set messages as read
  void setMessagesAsRead() {
    try {
      logger.i('setMessagesAsRead');
      if (unreadMessageCount > 0) {
        final unreadMessageEventIds = state.messages
            .take(unreadMessageCount)
            .map((e) => e.remoteId!)
            .toList();
        logger.i(
          'unread message event ids lenght: ${unreadMessageEventIds.length}',
        );
        markMessageAsRead(unreadMessageEventIds);
      }
    } catch (e, s) {
      logger.e('e: $e, s: $s');
    }
  }

  Future<List<Message>> _retriveMessagesFromDB(String roomId) async {
    final room = client?.getRoomById(roomId);
    if (room == null) return [];
    final events = await client!.database?.getEventList(room);
    if (events == null || events.isEmpty) return [];
    final messageEvents =
        events.where((event) => event.type == 'm.room.message').toList()
          ..sort(
            (e1, e2) => e2.originServerTs.compareTo(e1.originServerTs),
          );
    return messageEvents.map(_mapEventToMessage).toList();
  }

  Future<void> _checkIfRoomNotExistThenCreateIt() async {
    if (_roomId == null || _roomId!.isEmpty) {
      final did = await secureStorageProvider.get(SecureStorageKeys.did) ?? '';
      final username = did.replaceAll(':', '-');
      _roomId = await _createRoomAndInviteSupport(
        username,
      );
      await _setRoomIdInStorage(_roomId!);
      _getUnreadMessageCount();
      await _subscribeToEventsOfRoom();
    }
  }

  Future<String?> _getRoomIdFromStorage() async {
    return secureStorageProvider.get(SecureStorageKeys.supportRoomId);
  }

  Future<void> _setRoomIdInStorage(String roomId) async {
    await secureStorageProvider.set(
      SecureStorageKeys.supportRoomId,
      roomId,
    );
  }

  /// before calling this function you need to check if
  /// room not exist before with this [name] and alias
  Future<String> _createRoomAndInviteSupport(String name) async {
    try {
      final roomId = await client!.createRoom(
        isDirect: true,
        name: name,
        invite: ['@support:matrix.talao.co'],
        roomAliasName: name,
        initialState: [
          StateEvent(
            type: EventTypes.Encryption,
            stateKey: '',
            content: {
              'algorithm': 'm.megolm.v1.aes-sha2',
            },
          ),
        ],
      );
      await _enableRoomEncyption(roomId);
      logger.i('room created! => id: $roomId');
      return roomId;
    } catch (e, s) {
      logger.e('e: $e, s: $s');
      if (e is MatrixException && e.errcode == 'M_ROOM_IN_USE') {
        final millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
        return _createRoomAndInviteSupport(
          '$name-updated-$millisecondsSinceEpoch',
        );
      } else {
        final roomId = await client!.joinRoom(name);
        await _enableRoomEncyption(roomId);
        return roomId;
      }
    }
  }

  Future<void> _enableRoomEncyption(String roomId) async {
    try {
      if (roomId.isEmpty) return;
      final room = client?.getRoomById(roomId);
      if (room == null) return;
      if (room.encrypted) {
        logger.i('the room with id: ${room.id} encyrpted before!');
        return;
      }
      await room.enableEncryption();
      final verificationResponse =
          await DeviceKeysList(client!.userID!, client!).startVerification();
      logger.i('verification response: $verificationResponse');
      await verificationResponse.acceptVerification();
    } catch (e, s) {
      logger.e('error in enabling room e2e encryption, e: $e, s: $s');
    }
  }

  Future<void> _initClient() async {
    try {
      client = Client(
        'AltMeUser',
        databaseBuilder: (_) async {
          final dir = await getApplicationSupportDirectory();
          final db = HiveCollectionsDatabase('matrix_support_chat', dir.path);
          await db.open();
          return db;
        },
      );
      client!.homeserver = Uri.parse(Urls.matrixHomeServer);
      await client!.init();
      _notificationStreamController ??= StreamController<int>.broadcast();
    } catch (e, s) {
      logger.e('e: $e , s: $s');
      await client!.init(
        newHomeserver: Uri.parse(Urls.matrixHomeServer),
      );
    }
  }

  Future<String> _getDidAuth(String did, String nonce) async {
    final verificationMethod =
        await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

    final options = <String, dynamic>{
      'verificationMethod': verificationMethod,
      'proofPurpose': 'authentication',
      'challenge': nonce,
      'domain': 'issuer.talao.co',
    };

    final key = (await secureStorageProvider.get(SecureStorageKeys.ssiKey))!;

    final String didAuth = await didKit.didAuth(
      did,
      jsonEncode(options),
      key,
    );

    return didAuth;
  }

  Future<String> _getNonce(String did) async {
    await dotenv.load();
    final apiKey = dotenv.get('TALAO_MATRIX_API_KEY');
    final nonce = await dioClient.get(
      Urls.getNonce,
      queryParameters: <String, dynamic>{
        'did': did,
      },
      headers: <String, dynamic>{
        'X-API-KEY': apiKey,
      },
    ) as String;
    return nonce;
  }

  Future<String> _getPasswordForDID() async {
    final ssiKey = (await secureStorageProvider.get(SecureStorageKeys.ssiKey))!;
    final bytesToHash = utf8.encode(ssiKey);
    final sha256Digest = sha256.convert(bytesToHash);
    final password = sha256Digest.toString();
    return password;
  }

  Future<void> _register({
    required String did,
  }) async {
    final nonce = await _getNonce(did);
    final didAuth = await _getDidAuth(did, nonce);
    await dotenv.load();
    final apiKey = dotenv.get('TALAO_MATRIX_API_KEY');
    final password = await _getPasswordForDID();

    final data = <String, dynamic>{
      'username': did,
      'password': password,
      'didAuth': didAuth,
    };
    final response = await dioClient.post(
      Urls.registerToMatrix,
      headers: <String, dynamic>{
        'X-API-KEY': apiKey,
        'Content-Type': 'application/json',
      },
      data: data,
    );

    logger.i('regester response: $response');
  }

  Future<String> _login({
    required String username,
    required String password,
  }) async {
    try {
      final isLogged = client!.isLogged();
      if (isLogged) return client!.userID!;
      client!.homeserver = Uri.parse(Urls.matrixHomeServer);
      final deviceId = await PlatformDeviceId.getDeviceId;
      final loginResonse = await client!.login(
        LoginType.mLoginPassword,
        password: password,
        deviceId: deviceId,
        identifier: AuthenticationUserIdentifier(user: username),
      );
      return loginResonse.userId!;
    } catch (e, s) {
      logger.i('e: $e, s: $s');
      return '@$username:${Urls.matrixHomeServer.replaceAll('https://', '')}';
    }
  }

  Future<void> dispose() async {
    try {
      await client?.logout().catchError((_) => null);
      await client?.dispose().catchError((_) => null);
      await _notificationStreamController?.close().catchError((_) => null);
      _notificationStreamController = null;
      await _onEventSubscription?.cancel().catchError((_) => null);
      _onEventSubscription = null;
      _roomId = null;
      client = null;
    } catch (e, s) {
      logger.e('e: $e, s: $s');
    }
  }

  String _getUrlFromUri(String uri) {
    return '${Urls.matrixHomeServer}/_matrix/media/v3/thumbnail/${Urls.matrixHomeServer.replaceAll('https://', '')}/${uri.split('/').last}?width=500&height=500';
  }

  Status _mapEventStatusToMessageStatus(EventStatus status) {
    switch (status) {
      case EventStatus.error:
        return Status.error;
      case EventStatus.removed:
        return Status.error;
      case EventStatus.roomState:
        return Status.delivered;
      case EventStatus.sending:
        return Status.sending;
      case EventStatus.sent:
        return Status.sent;
      case EventStatus.synced:
        return Status.seen;
    }
  }
}
