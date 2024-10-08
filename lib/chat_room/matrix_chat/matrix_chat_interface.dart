import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:logger/logger.dart';
import 'package:matrix/matrix.dart' hide User;

abstract class MatrixChatInterface {
  Client? client;
  User? user;
  final Logger logger = getLogger('MatrixChatInterface');
  Future<void> onSendPressed({
    required PartialText partialText,
    required OnMessageCreated onMessageCreated,
  });
  Future<String> createRoomAndInviteSupport(
    String roomName,
    List<String>? invites,
  );
  Future<String> joinRoom(String roomName);
  Future<void> enableRoomEncyption(String roomId);
  Future<void> handleImageSelection({
    required OnMessageCreated onMessageCreated,
  });
  Future<void> handleFileSelection({
    required OnMessageCreated onMessageCreated,
  });
  Message mapEventToMessage(Event event);
  Status mapEventStatusToMessageStatus(EventStatus status);
  String getThumbnail({
    required String url,
    int width = 500,
    int height = 500,
  });
  Future<String> login({
    required String username,
    required String password,
  });
  Future<void> register({
    required String did,
    required String kid,
    required String privateKey,
  });
  Future<void> dispose();
  Future<void> init(ProfileCubit profileCubit);
  Future<String?> getRoomIdFromStorage(String roomIdStoredKey);
  Future<void> setRoomIdInStorage(String roomIdStoredKey, String roomId);
  Future<void> clearRoomIdInStorage(String roomIdStoredKey);
  int getUnreadMessageCount(String? roomId);
  Future<List<Message>> retriveMessagesFromDB(String roomId);
  Future<void> markMessageAsRead(
    List<String?>? eventIds,
    String? roomId,
  );
}
