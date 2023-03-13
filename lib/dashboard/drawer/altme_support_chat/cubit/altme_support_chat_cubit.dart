import 'package:altme/dashboard/dashboard.dart';

class AltmeChatSupportCubit extends ChatRoomCubit {
  AltmeChatSupportCubit({
    required super.secureStorageProvider,
    required super.matrixChat,
    required super.invites,
    required super.storageKey,
    required super.roomNamePrefix,
  });
}
