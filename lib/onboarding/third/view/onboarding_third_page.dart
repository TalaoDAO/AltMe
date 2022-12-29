import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/route/route.dart';
import 'package:flutter/material.dart';

class OnBoardingThirdPage extends StatelessWidget {
  const OnBoardingThirdPage({Key? key}) : super(key: key);

  static Route route() => RightToLeftRoute<void>(
        builder: (context) => const OnBoardingThirdPage(),
        settings: const RouteSettings(name: '/onBoardingThirdPage'),
      );

  @override
  Widget build(BuildContext context) {
    return const OnBoardingThirdView();
  }
}

class OnBoardingThirdView extends StatefulWidget {
  const OnBoardingThirdView({Key? key}) : super(key: key);

  static Route route() => RightToLeftRoute<void>(
        builder: (context) => const OnBoardingThirdView(),
        settings: const RouteSettings(name: '/onBoardingThirdPage'),
      );

  @override
  State<OnBoardingThirdView> createState() => _OnBoardingThirdViewState();
}

class _OnBoardingThirdViewState extends State<OnBoardingThirdView> {
  bool animate = true;

  void disableAnimation() {
    animate = false;
    Future.delayed(const Duration(seconds: 1), () {
      animate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onHorizontalDragUpdate: (drag) async {
        if (animate) {
          if (drag.delta.dx > 2) {
            Navigator.of(context).pop();
            disableAnimation();
          }
        }
      },
      child: BasePage(
        scrollView: false,
        body: OnBoardingWidget(
          title: l10n.onBoardingThirdTitle,
          subtitle: l10n.onBoardingThirdSubtitle,
          image: ImageStrings.onBoardingThirdImage,
          index: 3,
        ),
      ),
    );
  }
}
