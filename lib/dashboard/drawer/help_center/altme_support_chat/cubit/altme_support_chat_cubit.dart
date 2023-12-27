import 'package:altme/chat_room/chat_room.dart';

class AltmeChatSupportCubit extends ChatRoomCubit {
  AltmeChatSupportCubit({
    required super.secureStorageProvider,
    required super.matrixChat,
    required super.invites,
  });
}
