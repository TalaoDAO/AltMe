import 'package:altme/app/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class SecretKeyCubit extends Cubit<String> {
  SecretKeyCubit({
    required this.keyGenerator,
    required this.secureStorageProvider,
  }) : super('') {
    initialise();
  }

  final KeyGenerator keyGenerator;
  final SecureStorageProvider secureStorageProvider;

  Future<void> initialise() async {
    final mnemonic =
        await secureStorageProvider.get(SecureStorageKeys.mnemonic);
    final String secretKey = await keyGenerator.secretKey(mnemonic!);
    emit(secretKey);
  }
}
