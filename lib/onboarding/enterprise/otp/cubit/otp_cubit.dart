import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_cubit.g.dart';

part 'otp_state.dart';

class EnterpriseOTPCubit extends Cubit<EnterpriseOTPState> {
  EnterpriseOTPCubit() : super(const EnterpriseOTPState());

  void updateOTPCorrectionStatus({required bool value}) {
    emit(state.copyWith(isOTPCorrect: value));
  }
}
