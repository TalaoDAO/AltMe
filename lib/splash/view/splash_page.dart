import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addStatusListener((AnimationStatus status) async {
            if (status == AnimationStatus.completed) {
               await context.read<ThemeCubit>().getCurrentTheme();
              // await Navigator.of(context)
              //     .push<void>(ThemePage.route(context.read<ThemeCubit>()));
            }
          });
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffffffff),
      scrollView: false,
      body: Center(
        child: SizedBox.square(
          dimension: MediaQuery.of(context).size.width * 0.4,
          child: ScaleTransition(
            key: const Key('scaleTransition'),
            scale: _scaleAnimation,
            child: Image.asset(ImageStrings.splash),
          ),
        ),
      ),
    );
  }
}
