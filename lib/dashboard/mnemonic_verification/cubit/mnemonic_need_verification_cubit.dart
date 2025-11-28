import 'package:flutter_bloc/flutter_bloc.dart';

class MnemonicNeedVerificationCubit extends Cubit<bool> {
  MnemonicNeedVerificationCubit() : super(false);

  void needToVerifyMnemonic({required bool needToVerify}) {
    emit(needToVerify);
  }
}
