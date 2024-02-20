import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:matrix/matrix.dart' hide User;
import 'package:oidc4vc/oidc4vc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_storage/secure_storage.dart';

part 'chat_room_cubit.g.dart';
part 'chat_room_state.dart';

abstract class ChatRoomCubit extends Cubit<ChatRoomState> {
  ChatRoomCubit({
    required this.secureStorageProvider,
    required this.matrixChat,
    required this.profileCubit,
  }) : super(const ChatRoomState());

  final SecureStorageProvider secureStorageProvider;
  final logger = getLogger('ChatRoomCubit');
  String? _roomId;
  StreamSubscription<Event>? _onEventSubscription;
  StreamController<int>? _notificationStreamController =
      StreamController<int>.broadcast();

  //
  final MatrixChatImpl matrixChat;
  final ProfileCubit profileCubit;

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
      final user = await matrixChat.init(profileCubit);
      _notificationStreamController ??= StreamController<int>.broadcast();

      List<Message> retrivedMessageFromDB = [];
      await _checkIfRoomNotExistThenCreateIt();
      final savedRoomId = await matrixChat.getRoomIdFromStorage();
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
        emitError(e);
      }
    }
  }

  void emitError(dynamic e) {
    final messageHandler = getMessageHandler(e);

    emit(
      state.copyWith(
        status: AppStatus.error,
        message: StateMessage.error(
          messageHandler: messageHandler,
          showDialog: true,
        ),
      ),
    );
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
          emit(
            state.copyWith(
              messages: [message, ...state.messages],
            ),
          );
        }

        setMessagesAsRead();

        Future<void>.delayed(const Duration(seconds: 1))
            .then((val) => _getUnreadMessageCount());
      }
    });
  }

  void hardCodeAllMessageAsRead() {
    _notificationStreamController?.sink.add(0);
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
            .map((e) => e.remoteId)
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
      final p256KeyForWallet = await getWalletP256Key(secureStorageProvider);

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      final tokenParameters = TokenParameters(
        privateKey: jsonDecode(p256KeyForWallet) as Map<String, dynamic>,
        did: '', // just added as it is required field
        mediaType: MediaType.basic, // just added as it is required field
        clientType:
            ClientType.jwkThumbprint, // just added as it is required field
        proofHeaderType: customOidc4vcProfile.proofHeader,
        clientId: customOidc4vcProfile.clientId ?? '',
      );

      final helpCenterOptions =
          profileCubit.state.model.profileSetting.helpCenterOptions;

      final List<String> invites = [];

      if (profileCubit.state.model.walletType == WalletType.enterprise &&
          helpCenterOptions.customChatSupport &&
          helpCenterOptions.customChatSupportName != null) {
        invites.add(helpCenterOptions.customChatSupportName!);
      } else {
        invites.add(AltMeStrings.matrixSupportId);
      }

      _roomId = await matrixChat.createRoomAndInviteSupport(
        tokenParameters.thumbprint,
        invites,
      );

      await matrixChat.setRoomIdInStorage(_roomId!);
      _getUnreadMessageCount();
      await _subscribeToEventsOfRoom();
    }
  }

  Future<void> dispose() async {
    try {
      await _notificationStreamController?.close().catchError((_) => null);
      _notificationStreamController = null;
      await _onEventSubscription?.cancel().catchError((_) => null);
      _onEventSubscription = null;
      _roomId = null;
      await matrixChat.dispose();
    } catch (e, s) {
      logger.e('e: $e, s: $s');
    }
  }
}
