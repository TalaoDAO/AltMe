import 'package:flutter/material.dart';

class CardAnimationState {
  CardAnimationState(this.cardWidget);

  final Widget cardWidget;

  CardAnimationState copyWith(Widget cardWidget) {
    return CardAnimationState(cardWidget);
  }
}