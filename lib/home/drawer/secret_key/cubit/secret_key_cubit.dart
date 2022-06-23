import 'package:altme/app/shared/constants/secure_storage_keys.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecretKeyCubit extends Cubit<String> {
  SecretKeyCubit({
    required this.walletCubit,
  }) : super('') {
    initialise();
  }

  final WalletCubit walletCubit;

  Future<void> initialise() async {
    // TODO(all): may be we need list later we have active right now
    final activeIndex = walletCubit.state.currentCryptoIndex;
    final secretKey = await walletCubit.secureStorageProvider
        .get('${SecureStorageKeys.cryptoSecretKey}/$activeIndex');

    emit(secretKey ?? '');
  }
}
