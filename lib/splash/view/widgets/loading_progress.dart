import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class LoadingProgress extends StatefulWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  State<LoadingProgress> createState() => _LoadingProgressState();
}

class _LoadingProgressState extends State<LoadingProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4 * 1000),
    );

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _animationController.forward(from: 0);
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceLarge),
      child: LayoutBuilder(
        builder: (_, boxConstraints) {
          final maxWidth = boxConstraints.maxWidth;
          return Container(
            width: maxWidth,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSecondary,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(35),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: _animationController.value * maxWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
