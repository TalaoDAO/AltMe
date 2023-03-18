import 'dart:async';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:matrix/matrix.dart' hide User;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_storage/secure_storage.dart';

part 'chat_room_cubit.g.dart';
part 'chat_room_state.dart';

abstract class ChatRoomCubit extends Cubit<ChatRoomState> {
  ChatRoomCubit({
    required this.secureStorageProvider,
    required this.matrixChat,
    required this.invites,
    required this.storageKey,
    required this.roomNamePrefix,
  }) : super(
          const ChatRoomState(),
        ) {
    secureStorageProvider.get(SecureStorageKeys.did).then((did) {
      if (did != null && did.isNotEmpty) {
        init();
      }
    });
  }

  final SecureStorageProvider secureStorageProvider;
  final logger = getLogger('ChatRoomCubit');
  String? _roomId;
  StreamSubscription<Event>? _onEventSubscription;
  StreamController<int>? _notificationStreamController;
  final List<String>? invites;
  final String storageKey;
  final String roomNamePrefix;

  //
  final MatrixChatImpl matrixChat;

  Stream<int> get unreadMessageCountStream {
    _notificationStreamController ??= StreamController<int>.broadcast();
    return _notificationStreamController!.stream;
  }

  Future<void> onSendPressed(PartialText partialText) async {
    return matrixChat.onSendPressed(
      partialText: partialText,
      onMessageCreated: (message) async {
        emit(state.copyWith(messages: [message, ...state.messages]));
        //
        await _checkIfRoomNotExistThenCreateIt();
        return _roomId!;
      },
    );
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

  Future<void> handleFileSelection() {
    return matrixChat.handleFileSelection(
      onMessageCreated: (message) async {
        emit(state.copyWith(messages: [message, ...state.messages]));
        await _checkIfRoomNotExistThenCreateIt();
        return _roomId!;
      },
    );
  }

  Future<void> handleImageSelection() {
    return matrixChat.handleImageSelection(
      onMessageCreated: (message) async {
        emit(state.copyWith(messages: [message, ...state.messages]));

        await _checkIfRoomNotExistThenCreateIt();
        return _roomId!;
      },
    );
  }

  Future<void> init() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final user = await matrixChat.init();
      _notificationStreamController ??= StreamController<int>.broadcast();

      List<Message> retrivedMessageFromDB = [];
      final savedRoomId = await matrixChat.getRoomIdFromStorage(storageKey);
      if (savedRoomId != null) {
        _roomId = savedRoomId;
        await matrixChat.enableRoomEncyption(savedRoomId);
        _getUnreadMessageCount();
        await _subscribeToEventsOfRoom();
        retrivedMessageFromDB =
            await matrixChat.retriveMessagesFromDB(_roomId!);
      }
      logger.i('roomId : $_roomId');
      emit(
        state.copyWith(
          status: AppStatus.init,
          user: user,
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

    _onEventSubscription =
        matrixChat.client!.onRoomState.stream.listen((Event event) {
      if (event.roomId == _roomId && event.type == 'm.room.message') {
        final txId = event.unsigned?['transaction_id'] as String?;
        if (state.messages.any(
          (element) => element.id == txId,
        )) {
          final index = state.messages.indexWhere(
            (element) => element.id == txId,
          );
          final updatedMessage = state.messages[index].copyWith(
            status: matrixChat.mapEventStatusToMessageStatus(event.status),
          );
          final newMessages = List.of(state.messages);
          newMessages[index] = updatedMessage;
          emit(state.copyWith(messages: newMessages));
        } else {
          final Message message = matrixChat.mapEventToMessage(event);
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

  int get unreadMessageCount => matrixChat.getUnreadMessageCount(_roomId);

  void _getUnreadMessageCount() {
    final unreadCount = unreadMessageCount;
    logger.i('unread message count: $unreadCount');
    _notificationStreamController?.sink.add(unreadCount);
  }

  Future<void> markMessageAsRead(List<String?>? eventIds) async {
    if (eventIds == null || eventIds.isEmpty) return;
    await matrixChat.markMessageAsRead(eventIds, _roomId);
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

  Future<void> _checkIfRoomNotExistThenCreateIt() async {
    if (_roomId == null || _roomId!.isEmpty) {
      final did = await secureStorageProvider.get(SecureStorageKeys.did) ?? '';
      final username = did.replaceAll(':', '-');
      _roomId = await matrixChat.createRoomAndInviteSupport(
        '$roomNamePrefix-$username',
        invites,
      );
      await matrixChat.setRoomIdInStorage(
        storageKey,
        _roomId!,
      );
      _getUnreadMessageCount();
      await _subscribeToEventsOfRoom();
    }
  }

  Future<void> dispose() async {
    try {
      await matrixChat.dispose();
      await _notificationStreamController?.close().catchError((_) => null);
      _notificationStreamController = null;
      await _onEventSubscription?.cancel().catchError((_) => null);
      _onEventSubscription = null;
      _roomId = null;
    } catch (e, s) {
      logger.e('e: $e, s: $s');
    }
  }
}
