import 'package:altme/app/app.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class SecretKeyCubit extends Cubit<String> {
  SecretKeyCubit({
    required this.keyGenerator,
    required this.secureStorageProvider,
    required this.walletCubit,
  }) : super('') {
    initialise();
  }

  final KeyGenerator keyGenerator;
  final SecureStorageProvider secureStorageProvider;
  final WalletCubit walletCubit;

  Future<void> initialise() async {
    final activeIndex = walletCubit.state.currentIndex;
    final mnemonic = await secureStorageProvider.get(
      '${SecureStorageKeys.menomicss}/$activeIndex',
    );
    final String secretKey =
        await keyGenerator.secretKeyFromMnemonic(mnemonic!);
    emit(secretKey);
  }
}
