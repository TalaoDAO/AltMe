
import 'dart:math';

import 'package:flutter/material.dart';

abstract class Recto extends StatelessWidget {
  const Recto({Key? key});
}
abstract class Verso extends StatelessWidget {
  const Verso();
}

class CardAnimation extends StatefulWidget {
  final Verso verso;

  final Recto recto;

  const CardAnimation({
    Key? key,
    required this.recto,
    required this.verso,
  }) : super(key: key);

  @override
  State<CardAnimation> createState() =>
      _CardAnimationState();
}


class _CardAnimationState extends State<CardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Widget _card;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      value: 1,
    );
    _card = widget.recto;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await _animationController.reverse();
          setState(() {
            if (_card is Recto) {
              _card = widget.verso;
            } else {
              _card = widget.recto;
            }
          });
          await _animationController.forward();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform:
                  Matrix4.rotationX((1 - _animationController.value) * pi / 2),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(9, 9),
                      blurRadius: 10,
                      spreadRadius: 5.0,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: _card,
              ),
            );
          },
        ));
  }
}
