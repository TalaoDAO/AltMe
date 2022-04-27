import 'package:altme/app/shared/widget/card_animation/card_animation_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class CardAnimationCubit extends Cubit<CardAnimationState> {
  CardAnimationCubit(Widget cardWidget) : super(CardAnimationState(cardWidget));

  void setCardWidget(Widget cardWidget) {
    emit(state.copyWith(cardWidget));
  }
}
