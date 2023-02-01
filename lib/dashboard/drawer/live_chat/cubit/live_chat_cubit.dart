import 'dart:async';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
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
    required this.secureStorageProvider,
    required this.client,
    required User user,
  }) : super(
          LiveChatState(user: user),
        );

  final SecureStorageProvider secureStorageProvider;
  final Client client;
  final logger = getLogger('LiveChatCubit');
  String _roomId = '';
  StreamSubscription<Event>? _onEventSubscription;

  Future<void> onSendPressed(PartialText partialText) async {
    final message = TextMessage(
      author: state.user,
      id: const Uuid().v4(),
      text: partialText.text,
    );
    emit(state.copyWith(messages: [message, ...state.messages]));

    await client.getRoomById(_roomId)?.sendTextEvent(partialText.text);
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

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
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
      final message = FileMessage(
        author: state.user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );
      emit(state.copyWith(messages: [message, ...state.messages]));

      await client.getRoomById(_roomId)?.sendFileEvent(
            MatrixFile(
              bytes: result.files.single.bytes!,
              name: result.files.single.name,
            ),
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

      final message = ImageMessage(
        author: state.user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      emit(state.copyWith(messages: [message, ...state.messages]));

      await client.getRoomById(_roomId)?.sendFileEvent(
            MatrixFile(
              bytes: bytes,
              name: result.name,
            ),
          );
    }
  }

  Future<void> init() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      await _initClient();
      await _login();
      _roomId = await _createRoomAndInviteSupport();
      _subscribeToEventsOfRoom();
      emit(state.copyWith(status: AppStatus.init));
    } catch (e, s) {
      logger.e('error: $e, stack: $s');
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  void _subscribeToEventsOfRoom() {
    _onEventSubscription?.cancel();
    _onEventSubscription = client.onRoomState.stream.listen((Event event) {
      logger.i('onEvent roomId: ${event.roomId} senderId: ${event.senderId}');
      if (event.roomId == _roomId && event.senderId != state.user.id) {
        late final TextMessage message;
        if (event.messageType == 'm.text') {
          message = TextMessage(
            id: const Uuid().v4(),
            text: event.text,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            author: User(
              id: event.senderId,
            ),
          );
        } else if (event.messageType == 'file') {}
        emit(
          state.copyWith(
            messages: [message, ...state.messages],
          ),
        );
      }
    });
  }

  Future<String> _createRoomAndInviteSupport() async {
    final mRoomId =
        await secureStorageProvider.get(SecureStorageKeys.supportRoomId);
    if (mRoomId == null) {
      final roomId = await client.createRoom(
        isDirect: true,
        name: 'AltMe-Support',
        roomAliasName: 'AltMe-Support',
      );
      await secureStorageProvider.set(SecureStorageKeys.supportRoomId, roomId);
      return roomId;
    } else {
      return mRoomId;
    }
  }

  Future<void> _initClient() async {
    await dotenv.load();
    final homeServer = dotenv.get('MATRIX_HOME_SERVER');
    client.homeserver = Uri.parse(homeServer);
    await client.init();
  }

  Future<void> _login() async {
    final username = dotenv.get('MATRIX_USERNAME');
    final password = dotenv.get('MATRIX_PASSWORD');
    await client.login(
      LoginType.mLoginPassword,
      password: password,
      identifier: AuthenticationUserIdentifier(user: username),
    );
  }

  Future<void> dispose() async {
    await client.logout();
    await client.dispose();
    await _onEventSubscription?.cancel();
  }
}
