import 'package:altme/dashboard/dashboard.dart';

class LoyaltyCardSupportChatCubit extends ChatRoomCubit {
  LoyaltyCardSupportChatCubit({
    required super.secureStorageProvider,
    required super.matrixChat,
    required super.invites,
    required super.storageKey,
    required super.roomNamePrefix,
  });
}
