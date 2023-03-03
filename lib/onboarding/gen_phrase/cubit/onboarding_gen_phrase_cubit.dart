import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'onboarding_gen_phrase_cubit.g.dart';

part 'onboarding_gen_phrase_state.dart';

class OnBoardingGenPhraseCubit extends Cubit<OnBoardingGenPhraseState> {
  OnBoardingGenPhraseCubit() : super(const OnBoardingGenPhraseState());

  final log = getLogger('OnBoardingGenPhraseCubit');

  Future<void> switchTick() async {
    emit(state.copyWith(isTicked: !state.isTicked));
  }
}
