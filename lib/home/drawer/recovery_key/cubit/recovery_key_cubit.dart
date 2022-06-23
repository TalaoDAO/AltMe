import 'package:altme/app/app.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'recovery_key_cubit.g.dart';

part 'recovery_key_state.dart';

class RecoveryKeyCubit extends Cubit<RecoveryKeyState> {
  RecoveryKeyCubit({
    required this.secureStorageProvider,
    required this.walletCubit,
  }) : super(const RecoveryKeyState()) {
    loadMnemonic();
  }

  final SecureStorageProvider secureStorageProvider;
  final WalletCubit walletCubit;

  Future<void> loadMnemonic() async {
    emit(state.loading());

    final phrase = await secureStorageProvider.get(
      SecureStorageKeys.ssiMnemonic,
    );
    emit(state.success(mnemonic: phrase!.split(' ')));
  }
}
