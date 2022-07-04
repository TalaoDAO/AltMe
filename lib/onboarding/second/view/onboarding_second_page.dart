import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

// TODO(bibash): PageView
class OnBoardingSecondPage extends StatefulWidget {
  const OnBoardingSecondPage({Key? key}) : super(key: key);

  static Route route() => RightToLeftRoute<void>(
        builder: (context) => const OnBoardingSecondPage(),
        settings: const RouteSettings(name: '/onBoardingSecondPage'),
      );

  @override
  State<OnBoardingSecondPage> createState() => _OnBoardingSecondPageState();
}

class _OnBoardingSecondPageState extends State<OnBoardingSecondPage> {
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

          if (drag.delta.dx < -2) {
            disableAnimation();
            await Navigator.of(context).push<void>(OnBoardingThirdPage.route());
          }
        }
      },
      child: BasePage(
        scrollView: false,
        body: OnBoardingWidget(
          title: l10n.onBoardingSecondTitle,
          subtitle: l10n.onBoardingSecondSubtitle,
          image: ImageStrings.onBoardingSecondImage,
          index: 2,
        ),
      ),
    );
  }
}
