part of 'card_animation_cubit.dart';

class CardAnimationState {
  CardAnimationState(this.cardWidget);

  final Widget cardWidget;

  CardAnimationState copyWith(Widget cardWidget) {
    return CardAnimationState(cardWidget);
  }
}
