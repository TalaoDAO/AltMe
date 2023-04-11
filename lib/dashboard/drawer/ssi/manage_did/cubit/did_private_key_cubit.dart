import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class DIDPrivateKeyCubit extends Cubit<String> {
  DIDPrivateKeyCubit({
    required this.secureStorageProvider,
  }) : super('...');

  final SecureStorageProvider secureStorageProvider;

  Future<void> initialize() async {
    final key =
        await secureStorageProvider.get(SecureStorageKeys.ssiKey) ?? '...';
    emit(key);
  }
}
