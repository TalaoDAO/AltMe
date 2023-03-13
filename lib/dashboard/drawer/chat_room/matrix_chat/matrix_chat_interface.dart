import 'dart:async';

import 'package:altme/app/app.dart';
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
  Future<void> enableRoomEncyption(String roomId);
  Future<void> handleImageSelection({
    required OnMessageCreated onMessageCreated,
  });
  Future<void> handleFileSelection({
    required OnMessageCreated onMessageCreated,
  });
  Message mapEventToMessage(Event event);
  Status mapEventStatusToMessageStatus(EventStatus status);
  String getUrlFromUri({
    required String uri,
    int width = 500,
    int height = 500,
  });
  Future<String> login({
    required String username,
    required String password,
  });
  Future<void> register({
    required String did,
  });
  Future<void> dispose();
  Future<void> init();
  Future<String?> getRoomIdFromStorage(String key);
  Future<void> setRoomIdInStorage(String key, String roomId);
  int getUnreadMessageCount(String? roomId);
  Future<List<Message>> retriveMessagesFromDB(String roomId);
  Future<void> markMessageAsRead(
    List<String?>? eventIds,
    String? roomId,
  );
}
