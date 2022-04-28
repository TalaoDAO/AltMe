import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'card_animation_state.dart';

class CardAnimationCubit extends Cubit<CardAnimationState> {
  CardAnimationCubit(Widget cardWidget) : super(CardAnimationState(cardWidget));

  void setCardWidget(Widget cardWidget) {
    emit(state.copyWith(cardWidget));
  }
}
