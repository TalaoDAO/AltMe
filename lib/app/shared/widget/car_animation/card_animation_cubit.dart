import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class CardAnimationState {
  CardAnimationState(this.cardWidget);

  final Widget cardWidget;

  CardAnimationState copyWith(Widget cardWidget) {
    return CardAnimationState(cardWidget);
  }
}

class CardAnimationCubit extends Cubit<CardAnimationState> {
  CardAnimationCubit(Widget cardWidget) : super(CardAnimationState(cardWidget));

  void setCardWidget(Widget cardWidget) {
    emit(state.copyWith(cardWidget));
  }
}
