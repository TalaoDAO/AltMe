import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/foundation.dart';

class TokenSelectBoxController extends ChangeNotifier {
  TokenSelectBoxController({required this.selectedToken});

  TokenModel selectedToken;

  void setSelectedAccount({required TokenModel selectedToken}) {
    this.selectedToken = selectedToken;
    notifyListeners();
  }
}
