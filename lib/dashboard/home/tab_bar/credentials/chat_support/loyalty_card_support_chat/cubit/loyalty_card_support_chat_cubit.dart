import 'package:altme/chat_room/chat_room.dart';

class LoyaltyCardSupportChatCubit extends ChatRoomCubit {
  LoyaltyCardSupportChatCubit({
    required super.secureStorageProvider,
    required super.matrixChat,
    required super.invites,
    required super.storageKey,
    required super.roomNamePrefix,
  });
}
