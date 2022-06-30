import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

class OnBoardingThirdPage extends StatefulWidget {
  const OnBoardingThirdPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingThirdPage(),
        settings: const RouteSettings(name: '/onBoardingThird'),
      );

  @override
  State<OnBoardingThirdPage> createState() => _OnBoardingThirdPageState();
}

class _OnBoardingThirdPageState extends State<OnBoardingThirdPage> {
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
