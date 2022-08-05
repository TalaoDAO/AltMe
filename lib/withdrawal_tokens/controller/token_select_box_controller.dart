import 'package:altme/wallet/wallet.dart';
import 'package:flutter/foundation.dart';

class AccountSelectBoxController extends ChangeNotifier {
  AccountSelectBoxController({CryptoAccountData? selectedAccount}) {
    _selectedAccount = selectedAccount;
  }

  CryptoAccountData? _selectedAccount;

  CryptoAccountData? get selectedAccount => _selectedAccount;

  void setSelectedAccount({required CryptoAccountData selectedAccount}) {
    _selectedAccount = selectedAccount;
    notifyListeners();
  }
}
