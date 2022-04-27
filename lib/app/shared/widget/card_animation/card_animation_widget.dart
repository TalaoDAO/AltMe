import 'dart:math';

import 'package:altme/app/shared/widget/card_animation/card_animation_cubit.dart';
import 'package:altme/app/shared/widget/card_animation/card_animation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Recto extends StatelessWidget {
  const Recto({Key? key}) : super(key: key);
}

abstract class Verso extends StatelessWidget {
  const Verso({Key? key}) : super(key: key);
}

class CardAnimationWidget extends StatefulWidget {
  const CardAnimationWidget({
    Key? key,
    required this.recto,
    required this.verso,
  }) : super(key: key);

  final Verso verso;

  final Recto recto;

  @override
  State<CardAnimationWidget> createState() => _CardAnimationWidgetState();
}

class _CardAnimationWidgetState extends State<CardAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final carAnimationCubit = CardAnimationCubit(widget.recto);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      value: 1,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CardAnimationCubit>.value(
      value: carAnimationCubit,
      child: GestureDetector(
        onTap: () async {
          await _animationController.reverse();
          if (carAnimationCubit.state.cardWidget is Recto) {
            carAnimationCubit.setCardWidget(widget.verso);
          } else {
            carAnimationCubit.setCardWidget(widget.recto);
          }
          await _animationController.forward();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform:
                  Matrix4.rotationX((1 - _animationController.value) * pi / 2),
              alignment: Alignment.center,
              child: BlocBuilder<CardAnimationCubit, CardAnimationState>(
                bloc: carAnimationCubit,
                builder: (context, state) {
                  return Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(9, 9),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: state.cardWidget,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
