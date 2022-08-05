import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/foundation.dart';

class TokenSelectBoxController extends ChangeNotifier {
  TokenSelectBoxController({TokenModel? selectedToken}) {
    _selectedToken = selectedToken;
  }

  TokenModel? _selectedToken;

  TokenModel? get selectedToken => _selectedToken;

  void setSelectedAccount({required TokenModel selectedToken}) {
    _selectedToken = selectedToken;
    notifyListeners();
  }
}
