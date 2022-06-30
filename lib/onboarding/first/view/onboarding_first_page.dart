import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/onboarding/widgets/page_tracker.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class OnBoardingFirstPage extends StatefulWidget {
  const OnBoardingFirstPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingFirstPage(),
        settings: const RouteSettings(name: '/onBoardingFirst'),
      );

  @override
  State<OnBoardingFirstPage> createState() => _OnBoardingFirstPageState();
}

class _OnBoardingFirstPageState extends State<OnBoardingFirstPage> {
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
          if (drag.delta.dx < -2) {
            disableAnimation();
            await Navigator.of(context)
                .push<void>(OnBoardingSecondPage.route());
          }
        }
      },
      child: BasePage(
        scrollView: false,
        body: OnBoardingWidget(
          title: l10n.onBoardingFirstTitle,
          subtitle: l10n.onBoardingFirstSubtitle,
          image: ImageStrings.onBoardingFirstImage,
          index: 1,
        ),
      ),
    );
  }
}
