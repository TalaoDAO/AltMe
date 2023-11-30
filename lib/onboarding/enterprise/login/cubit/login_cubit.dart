import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_cubit.g.dart';

part 'login_state.dart';

class EnterpriseLoginCubit extends Cubit<EnterpriseLoginState> {
  EnterpriseLoginCubit() : super(const EnterpriseLoginState());

  void updateEmailFormat(String email) {
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,}$';

    final regExpEmail = RegExp(emailPattern);

    final isValid = regExpEmail.hasMatch(email);
    emit(state.copyWith(isEmailFormatCorrect: isValid));
  }

  void updatePasswordFormat(String password) {
    emit(state.copyWith(isPasswordFormatCorrect: password.trim().length >= 3));
  }

  void obscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}
