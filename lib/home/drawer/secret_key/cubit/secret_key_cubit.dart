import 'package:altme/wallet/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';

class SecretKeyCubit extends Cubit<String> {
  SecretKeyCubit({
    required this.keyGenerator,
    required this.walletCubit,
  }) : super('') {
    initialise();
  }

  final KeyGenerator keyGenerator;
  final WalletCubit walletCubit;

  Future<void> initialise() async {
    //TODO(all): may be we need list later we have active right now
    final activeIndex = walletCubit.state.currentIndex!;
    final String secretKey = await keyGenerator.secretKeyFromMnemonic(
      mnemonic: walletCubit.state.walletAccounts[activeIndex].mnemonics!,
      accountType: walletCubit.state.walletAccounts[activeIndex].accountType,
      cryptoAccountLength: walletCubit.state.walletAccounts.length,
    );
    emit(secretKey);
  }
}
