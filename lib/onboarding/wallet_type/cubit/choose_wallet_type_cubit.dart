import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'choose_wallet_type_state.dart';

part 'choose_wallet_type_cubit.g.dart';

class ChooseWalletTypeCubit extends Cubit<ChooseWalletTypeState> {
  ChooseWalletTypeCubit(this.secureStorageProvider)
      : super(const ChooseWalletTypeState());

  final SecureStorageProvider secureStorageProvider;

  Future<void> onChangeWalletType(WalletType walletType) async {
    await secureStorageProvider.set(
      SecureStorageKeys.isEnterpriseUser,
      walletType == WalletType.personal ? false.toString() : true.toString(),
    );
    emit(state.copyWith(selectedWallet: walletType));
  }
}
