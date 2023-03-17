import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:crypto/crypto.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart' hide User;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

typedef OnMessageCreated = Future<String> Function(Message);

class MatrixChatImpl extends MatrixChatInterface {
  factory MatrixChatImpl() {
    _instance ??= MatrixChatImpl._(
      didKit: DIDKitProvider(),
      dioClient: DioClient('', Dio()),
      secureStorageProvider: getSecureStorage,
    );
    return _instance!;
  }

  MatrixChatImpl._({
    required this.didKit,
    required this.dioClient,
    required this.secureStorageProvider,
  }) {
    secureStorageProvider.get(SecureStorageKeys.did).then((did) {
      if (did != null && did.isNotEmpty) {
        init();
      }
    });
  }

  static MatrixChatImpl? _instance;

  final DIDKitProvider didKit;
  final DioClient dioClient;
  final SecureStorageProvider secureStorageProvider;

  @override
  Future<User> init() async {
    logger.i('init()');
    if (user != null) {
      return user!;
    }
    final ssiKey = await secureStorageProvider.get(SecureStorageKeys.ssiKey);
    final did = await secureStorageProvider.get(SecureStorageKeys.did) ?? '';
    final username = did.replaceAll(':', '-');
    if (ssiKey == null || ssiKey.isEmpty || did.isEmpty || username.isEmpty) {
      throw Exception(
        'ssiKey == null || ssiKey.isEmpty || did.isEmpty || username.isEmpty',
      );
    }

    await _initClient();
    final isUserRegisteredMatrix = await secureStorageProvider
        .get(SecureStorageKeys.isUserRegisteredMatrix);
    late String userId;
    if (isUserRegisteredMatrix != 'true') {
      await register(did: did);
      await secureStorageProvider.set(
        SecureStorageKeys.isUserRegisteredMatrix,
        true.toString(),
      );
      userId = await login(
        username: username,
        password: await _getPasswordForDID(),
      );
    } else {
      userId = await login(
        username: username,
        password: await _getPasswordForDID(),
      );
    }
    user = User(id: userId);
    return user!;
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
    } catch (e, s) {
      logger.e('e: $e , s: $s');
      await client!.init(
        newHomeserver: Uri.parse(Urls.matrixHomeServer),
      );
    }
  }

  @override
  Future<String?> getRoomIdFromStorage(String key) async {
    return secureStorageProvider.get(key);
  }

  @override
  Future<void> setRoomIdInStorage(String key, String roomId) async {
    await secureStorageProvider.set(
      key,
      roomId,
    );
  }

  @override
  int getUnreadMessageCount(String? roomId) =>
      client?.getRoomById(roomId ?? '')?.notificationCount ?? 0;

  @override
  Future<void> markMessageAsRead(
    List<String?>? eventIds,
    String? roomId,
  ) async {
    if (eventIds == null || eventIds.isEmpty) return;

    final room = client?.getRoomById(roomId ?? '');
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
  }

  @override
  Future<List<Message>> retriveMessagesFromDB(String roomId) async {
    final room = client?.getRoomById(roomId);
    if (room == null) return [];
    final events = await client!.database?.getEventList(room);
    if (events == null || events.isEmpty) return [];
    final messageEvents =
        events.where((event) => event.type == 'm.room.message').toList()
          ..sort(
            (e1, e2) => e2.originServerTs.compareTo(e1.originServerTs),
          );
    return messageEvents.map(mapEventToMessage).toList();
  }

  @override
  Message mapEventToMessage(Event event) {
    late final Message message;
    if (event.messageType == 'm.text') {
      message = TextMessage(
        id: event.unsigned?['transaction_id'] as String? ?? const Uuid().v4(),
        remoteId: event.eventId,
        text: event.text,
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        status: mapEventStatusToMessageStatus(event.status),
        author: User(
          id: event.senderId,
        ),
      );
    } else if (event.messageType == 'm.image') {
      message = ImageMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        name: event.body,
        size: event.content['info']['size'] as num? ?? 0,
        uri: getUrlFromUri(uri: event.content['url'] as String? ?? ''),
        status: mapEventStatusToMessageStatus(event.status),
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
        size: event.content['info']['size'] as num? ?? 0,
        uri: getUrlFromUri(uri: event.content['url'] as String? ?? ''),
        status: mapEventStatusToMessageStatus(event.status),
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
          milliseconds: event.content['info']['duration'] as int? ?? 0,
        ),
        name: event.body,
        size: event.content['info']['size'] as num? ?? 0,
        uri: getUrlFromUri(uri: event.content['url'] as String? ?? ''),
        status: mapEventStatusToMessageStatus(event.status),
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
        status: mapEventStatusToMessageStatus(event.status),
        author: User(
          id: event.senderId,
        ),
      );
    }
    return message;
  }

  @override
  Status mapEventStatusToMessageStatus(EventStatus status) {
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

  @override
  Future<void> onSendPressed({
    required PartialText partialText,
    required OnMessageCreated onMessageCreated,
  }) async {
    try {
      final messageId = const Uuid().v4();
      final message = TextMessage(
        author: user!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: messageId,
        text: partialText.text,
        status: Status.sending,
      );
      final roomId = await onMessageCreated.call(message);
      final room = client!.getRoomById(roomId);
      if (room == null) {
        await client!.joinRoomById(roomId);
      }
      final eventId = await client!.getRoomById(roomId)?.sendTextEvent(
            partialText.text,
            txid: messageId,
          );
      logger.i('send text event: $eventId');
    } catch (e, s) {
      logger.e('e: $e , s: $s');
    }
  }

  @override
  Future<void> handleFileSelection({
    required OnMessageCreated onMessageCreated,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final messageId = const Uuid().v4();
      final message = FileMessage(
        author: user!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: messageId,
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
        status: Status.sending,
      );
      final roomId = await onMessageCreated.call(message);
      final room = client!.getRoomById(roomId);
      if (room == null) {
        await client!.joinRoomById(roomId);
      }
      await client!.getRoomById(roomId)?.sendFileEvent(
            MatrixFile(
              bytes: File(result.files.single.path!).readAsBytesSync(),
              name: result.files.single.name,
            ),
            txid: messageId,
          );
    }
  }

  @override
  Future<void> handleImageSelection({
    required OnMessageCreated onMessageCreated,
  }) async {
    try {
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
          author: user!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: messageId,
          name: result.name,
          size: bytes.length,
          uri: result.path,
          width: image.width.toDouble(),
          status: Status.sending,
        );

        final roomId = await onMessageCreated.call(message);
        final room = client!.getRoomById(roomId);
        if (room == null) {
          await client!.joinRoomById(roomId);
        }
        await client!.getRoomById(roomId)?.sendFileEvent(
              MatrixFile(
                bytes: bytes,
                name: result.name,
              ),
              txid: messageId,
            );
      }
    } catch (e, s) {
      logger.e('e: $e, s: $s');
    }
  }

  /// before calling this function you need to check if
  /// room not exist before with this [roomName] and alias
  @override
  Future<String> createRoomAndInviteSupport(
    String roomName,
    List<String>? invites,
  ) async {
    try {
      final roomId = await client!.createRoom(
        isDirect: true,
        name: roomName,
        invite: invites,
        roomAliasName: roomName,
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
      await enableRoomEncyption(roomId);
      logger.i('room created! => id: $roomId');
      return roomId;
    } catch (e, s) {
      logger.e('e: $e, s: $s');
      if (e is MatrixException && e.errcode == 'M_ROOM_IN_USE') {
        final millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
        return createRoomAndInviteSupport(
          '$roomName-updated-$millisecondsSinceEpoch',
          invites,
        );
      } else {
        final roomId = await client!.joinRoom(roomName);
        await enableRoomEncyption(roomId);
        return roomId;
      }
    }
  }

  @override
  String getUrlFromUri({
    required String uri,
    int width = 500,
    int height = 500,
  }) {
    if (uri.trim().isEmpty) return '';
    return '${Urls.matrixHomeServer}/_matrix/media/v3/thumbnail/${Urls.matrixHomeServer.replaceAll('https://', '')}/${uri.split('/').last}?width=$width&height=$height';
  }

  @override
  Future<void> register({
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

  @override
  Future<String> login({
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

  @override
  Future<void> dispose() async {
    try {
      await client?.logout().catchError((_) => null);
      await client?.dispose().catchError((_) => null);
      user = null;
      client = null;
    } catch (e, s) {
      logger.e('e: $e, s: $s');
    }
  }

  @override
  Future<void> enableRoomEncyption(String roomId) async {
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
}
