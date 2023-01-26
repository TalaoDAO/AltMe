import 'dart:math';

import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

abstract class Recto extends StatelessWidget {
  const Recto({super.key});
}

abstract class Verso extends StatelessWidget {
  const Verso({super.key});
}

class CardAnimation extends StatefulWidget {
  const CardAnimation({
    super.key,
    required this.recto,
    required this.verso,
  });

  final Verso verso;

  final Recto recto;

  @override
  State<CardAnimation> createState() => _CardAnimationState();
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

        // TODO(all): remove setstate
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
            child: CredentialContainer(
              child: Container(alignment: Alignment.center, child: _card),
            ),
          );
        },
      ),
    );
  }
}
