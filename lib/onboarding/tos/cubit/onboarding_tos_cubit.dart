import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'onboarding_tos_cubit.g.dart';
part 'onboarding_tos_state.dart';

class OnBoardingTosCubit extends Cubit<OnBoardingTosState> {
  OnBoardingTosCubit() : super(const OnBoardingTosState());

  void setScrolledIsOver({required bool scrollIsOver}) {
    emit(state.copyWith(scrollIsOver: scrollIsOver));
  }

  void setAgreeTerms({required bool agreeTerms}) {
    emit(state.copyWith(agreeTerms: agreeTerms));
  }

  void setReadTerms({required bool readTerms}) {
    emit(state.copyWith(readTerms: readTerms));
  }

  void setAcceptanceButtonEnabled({required bool acceptanceButtonEnabled}) {
    emit(state.copyWith(acceptanceButtonEnabled: acceptanceButtonEnabled));
  }
}
