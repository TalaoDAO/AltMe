import 'package:altme/chat_room/chat_room.dart';

class MatrixNotificationCubit extends ChatRoomCubit {
  MatrixNotificationCubit({
    required super.secureStorageProvider,
    required super.matrixChat,
    required super.profileCubit,
    required super.roomIdStoredKey,
  });
}
