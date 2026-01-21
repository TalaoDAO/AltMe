import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'onboarding_cubit.g.dart';
part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  final log = getLogger('OnboardingCubit');

  Future<void> emitOnboardingProcessing() async {
    emit(state.copyWith(status: AppStatus.loading));
  }

  Future<void> emitOnboardingDone() async {
    emit(state.copyWith(status: AppStatus.success));
  }
}
