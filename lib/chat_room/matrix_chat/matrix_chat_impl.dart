import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:crypto/crypto.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart' hide User;
import 'package:mime/mime.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

typedef OnMessageCreated = Future<String> Function(Message);

class MatrixChatImpl extends MatrixChatInterface {
  factory MatrixChatImpl() {
    _instance ??= MatrixChatImpl._(
      didKitProvider: DIDKitProvider(),
      dioClient: DioClient(
        secureStorageProvider: getSecureStorage,
        dio: Dio(),
      ),
      secureStorageProvider: getSecureStorage,
      oidc4vc: OIDC4VC(),
    );
    return _instance!;
  }

  MatrixChatImpl._({
    required this.didKitProvider,
    required this.dioClient,
    required this.secureStorageProvider,
    required this.oidc4vc,
  });

  static MatrixChatImpl? _instance;

  final DIDKitProvider didKitProvider;
  final DioClient dioClient;
  final SecureStorageProvider secureStorageProvider;
  final OIDC4VC oidc4vc;

  @override
  Future<User> init(ProfileCubit profileCubit) async {
    logger.i('init()');
    if (client != null && user != null) {
      return user!;
    }

    // final didKeyType = profileCubit.state.model.profileSetting
    //     .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;

    final privateKey = await getPrivateKey(
      profileCubit: profileCubit,
      didKeyType: DidKeyType.edDSA,
    );

    final (did, kid) = await getDidAndKid(
      didKeyType: DidKeyType.edDSA,
      privateKey: privateKey,
      profileCubit: profileCubit,
    );

    final username = did.replaceAll(':', '-');

    await _initClient();
    final isUserRegisteredMatrix = await secureStorageProvider
        .get(SecureStorageKeys.isUserRegisteredMatrix);
    late String userId;
    if (isUserRegisteredMatrix != 'true') {
      await register(
        did: did,
        kid: kid,
        privateKey: privateKey,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.isUserRegisteredMatrix,
        true.toString(),
      );
    }
    userId = await login(
      username: username,
      password: await _getPasswordForDID(),
    );
    user = User(id: userId);
    return user!;
  }

  Future<void> _initClient() async {
    try {
      if (client != null) {
        await dispose();
      }
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
  Future<String?> getRoomIdFromStorage(String roomIdStoredKey) async {
    return secureStorageProvider.get(roomIdStoredKey);
  }

  @override
  Future<void> setRoomIdInStorage(String roomIdStoredKey, String roomId) async {
    await secureStorageProvider.set(roomIdStoredKey, roomId);
  }

  @override
  Future<void> clearRoomIdInStorage(String roomIdStoredKey) async {
    await secureStorageProvider.delete(roomIdStoredKey);
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
          await room.setReadMarker(eventId, mRead: eventId);
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
    num size = 0;
    if (event.content['info'] != null) {
      final info = event.content['info']! as Map;
      if (info['size'] != null) {
        size = info['size'] as num;
      }
    }

    if (event.messageType == 'm.text') {
      final redactedBecause = event.unsigned?['redacted_because'];

      message = TextMessage(
        id: event.unsigned?['transaction_id'] as String? ?? const Uuid().v4(),
        remoteId: event.eventId,
        text: redactedBecause != null ? 'Message deleted' : event.plaintextBody,
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        status: mapEventStatusToMessageStatus(event.status),
        author: User(id: event.senderId),
      );
    } else if (event.messageType == 'm.image') {
      final content = event.content;

      final file = content['file'];

      final url =
          (file != null && file is Map<String, dynamic>) ? file['url'] : '';

      message = ImageMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        name: event.plaintextBody,
        size: size,
        uri: url.toString(),
        metadata: {'event': event},
        status: mapEventStatusToMessageStatus(event.status),
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        author: User(id: event.senderId),
      );
    } else if (event.messageType == 'm.file') {
      message = FileMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        name: event.plaintextBody,
        size: size,
        uri: getThumbnail(url: event.content['url'] as String? ?? ''),
        status: mapEventStatusToMessageStatus(event.status),
        createdAt: event.originServerTs.millisecondsSinceEpoch,
        author: User(
          id: event.senderId,
        ),
      );
    } else if (event.messageType == 'm.audio') {
      var duration = 0;
      var size = 0;
      if (event.content['info'] != null) {
        final info = event.content['info']! as Map;
        if (info['duration'] != null) {
          duration = info['duration'] as int;
        }
        if (info['size'] != null) {
          size = info['size'] as int;
        }
      }
      message = AudioMessage(
        id: const Uuid().v4(),
        remoteId: event.eventId,
        duration: Duration(
          milliseconds: duration,
        ),
        name: event.plaintextBody,
        size: size,
        uri: getThumbnail(url: event.content['url'] as String? ?? ''),
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
        text: event.plaintextBody,
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
        await enableRoomEncyption(roomId);
      }
      final eventId = await room?.sendTextEvent(
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
        await enableRoomEncyption(roomId);
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
          await enableRoomEncyption(roomId);
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
      if (e is PlatformException && e.code == 'invalid_image') {
        logger.i(
          'If you are trying to send image from simulator or emulator'
          ' then you should use real device!',
        );
      }
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
      if (client == null) {
        await _initClient();
      }
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
        final clientRooms = List.of(client!.rooms);
        final result = clientRooms.where((element) => element.name == roomName);
        if (result.isEmpty) {
          try {
            final id = await client!.joinRoom(roomName);
            return id;
          } catch (_) {
            final millisecondsSinceEpoch =
                DateTime.now().millisecondsSinceEpoch;
            return createRoomAndInviteSupport(
              '$roomName-updated-$millisecondsSinceEpoch',
              invites,
            );
          }
        } else {
          await client!.joinRoom(result.first.id);
          return result.first.id;
        }
      } else {
        final roomId = await client!.joinRoom(roomName);
        await enableRoomEncyption(roomId);
        return roomId;
      }
    }
  }

  /// join room with [roomName]
  @override
  Future<String> joinRoom(String roomName) async {
    try {
      if (client == null) {
        await _initClient();
      }
      final roomId = await client!.joinRoom(roomName);
      await enableRoomEncyption(roomId);
      return roomId;
    } catch (e, s) {
      logger.e('e: $e, s: $s');
      throw Exception();
    }
  }

  @override
  String getThumbnail({
    required String url,
    int width = 500,
    int height = 500,
  }) {
    if (url.trim().isEmpty) return '';
    final Uri uri = Uri.parse(url).getThumbnail(
      client!,
      height: height,
      width: width,
      animated: false,
    );
    return uri.toString();
  }

  @override
  Future<void> register({
    required String did,
    required String kid,
    required String privateKey,
  }) async {
    final nonce = await _getNonce(did);
    final didAuth = await _getDidAuth(
      did: did,
      kid: kid,
      nonce: nonce,
      privateKey: privateKey,
    );
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

    logger.i('register response: $response');
  }

  Future<String> _getDidAuth({
    required String did,
    required String kid,
    required String nonce,
    required String privateKey,
  }) async {
    final options = <String, dynamic>{
      'verificationMethod': kid,
      'proofPurpose': 'authentication',
      'challenge': nonce,
      'domain': 'issuer.talao.co',
    };

    final String didAuth = await didKitProvider.didAuth(
      did,
      jsonEncode(options),
      privateKey,
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
      final loginResonse = await client!.login(
        LoginType.mLoginPassword,
        password: password,
        identifier: AuthenticationUserIdentifier(user: username),
      );
      return loginResonse.userId;
    } catch (e, s) {
      logger.i('e: $e, s: $s');
      return '@$username:${Urls.matrixHomeServer.replaceAll('https://', '')}'
          .toLowerCase();
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await client?.logout().catchError(
            (_) => logger.e('logout failed!'),
          );
      await client?.dispose().catchError(
            (dynamic e) => logger.e('dispose failed with $e'),
          );
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
