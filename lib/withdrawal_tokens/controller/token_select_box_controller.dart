import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';

class TokenSelectBoxController extends Cubit<TokenModel> {
  TokenSelectBoxController({required TokenModel selectedToken})
      : super(selectedToken);

  void setSelectedAccount({required TokenModel selectedToken}) {
    emit(selectedToken);
  }
}
