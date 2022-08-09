import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';

class AccountSelectBoxController extends Cubit<CryptoAccountData?> {
  AccountSelectBoxController({CryptoAccountData? selectedAccount})
      : super(selectedAccount);

  void setSelectedAccount({required CryptoAccountData selectedAccount}) {
    emit(selectedAccount);
  }
}
