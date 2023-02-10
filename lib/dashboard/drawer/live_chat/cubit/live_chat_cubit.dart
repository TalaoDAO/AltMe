import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
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
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'live_chat_cubit.g.dart';
part 'live_chat_state.dart';

class LiveChatCubit extends Cubit<LiveChatState> {
  LiveChatCubit({
    required this.didCubit,
    required this.secureStorageProvider,
    required this.client,
    required this.dioClient,
  }) : super(
          const LiveChatState(),
        ) {
    init();
  }

  final SecureStorageProvider secureStorageProvider;
  final Client client;
  final DioClient dioClient;
  final logger = getLogger('LiveChatCubit');
  String _roomId = '';
  StreamSubscription<Event>? _onEventSubscription;
  final DIDCubit didCubit;

  Future<void> onSendPressed(PartialText partialText) async {
    try {
      final eventId = await client.getRoomById(_roomId)?.sendTextEvent(
            partialText.text,
            txid: const Uuid().v4(),
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

      await client.getRoomById(_roomId)?.sendFileEvent(
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

      await client.getRoomById(_roomId)?.sendFileEvent(
            MatrixFile(
              bytes: bytes,
              name: result.name,
            ),
            txid: messageId,
          );
    }
  }

  Future<void> init() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      await _initClient();
      final username = didCubit.state.did!.replaceAll(':', '-');
      final isUserRegisteredMatrix = await secureStorageProvider
          .get(SecureStorageKeys.isUserRegisteredMatrix);
      late String userId;
      if (isUserRegisteredMatrix != 'true') {
        await _register(username: username);
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
      _roomId = await _createRoomAndInviteSupport(
        username,
      );
      logger.i('roomId : $_roomId');
      _subscribeToEventsOfRoom();
      emit(
        state.copyWith(
          status: AppStatus.init,
          user: User(id: userId),
        ),
      );
    } catch (e, s) {
      logger.e('error: $e, stack: $s');
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  void _subscribeToEventsOfRoom() {
    _onEventSubscription?.cancel();
    _onEventSubscription = client.onRoomState.stream.listen((Event event) {
      if (event.roomId == _roomId && event.type == 'm.room.message') {
        final txId = event.unsigned?['transaction_id'] as String?;
        if (state.messages.any(
          (element) => element.id == txId,
        )) {
          final index = state.messages.indexWhere(
            (element) => element.id == txId,
          );
          final updatedMessage = state.messages[index].copyWith(
            status: Status.delivered,
          );
          final newMessages = List.of(state.messages);
          newMessages[index] = updatedMessage;
          emit(state.copyWith(messages: newMessages));
        } else {
          late final Message message;
          if (event.messageType == 'm.text') {
            message = TextMessage(
              id: event.unsigned?['transaction_id'] as String? ??
                  const Uuid().v4(),
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
              text: event.text,
              createdAt: event.originServerTs.millisecondsSinceEpoch,
              status: _mapEventStatusToMessageStatus(event.status),
              author: User(
                id: event.senderId,
              ),
            );
          }
          emit(
            state.copyWith(
              messages: [message, ...state.messages],
            ),
          );
        }
      }
    });
  }

  Future<String> _createRoomAndInviteSupport(String name) async {
    final mRoomId =
        await secureStorageProvider.get(SecureStorageKeys.supportRoomId);
    if (mRoomId == null) {
      try {
        final roomId = await client.createRoom(
          isDirect: true,
          name: name,
          invite: ['@support:matrix.talao.co'],
          roomAliasName: name,
        );
        await secureStorageProvider.set(
          SecureStorageKeys.supportRoomId,
          roomId,
        );
        return roomId;
      } catch (e, s) {
        logger.e('e: $e, s: $s');
        final roomId = await client.joinRoom(name);
        return roomId;
      }
    } else {
      return mRoomId;
    }
  }

  Future<void> _initClient() async {
    client.homeserver = Uri.parse(Urls.matrixHomeServer);
    await client.init();
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

    final String didAuth = await didCubit.didKitProvider.didAuth(
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
    required String username,
  }) async {
    final did = didCubit.state.did!;
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
    client.homeserver = Uri.parse(Urls.matrixHomeServer);
    final loginResonse = await client.login(
      LoginType.mLoginPassword,
      password: password,
      identifier: AuthenticationUserIdentifier(user: username),
    );
    return loginResonse.userId!;
  }

  Future<void> dispose() async {
    await client.logout();
    await client.dispose();
    await _onEventSubscription?.cancel();
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
        return Status.seen;
      case EventStatus.sending:
        return Status.sending;
      case EventStatus.sent:
        return Status.sent;
      case EventStatus.synced:
        return Status.delivered;
    }
  }
}
