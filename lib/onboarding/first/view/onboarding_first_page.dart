import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

class OnBoardingFirstPage extends StatelessWidget {
  const OnBoardingFirstPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingFirstPage(),
        settings: const RouteSettings(name: '/onBoardingFirstPage'),
      );

  @override
  Widget build(BuildContext context) {
    return const OnBoardingFirstView();
  }
}

class OnBoardingFirstView extends StatefulWidget {
  const OnBoardingFirstView({Key? key}) : super(key: key);

  @override
  State<OnBoardingFirstView> createState() => _OnBoardingFirstViewState();
}

class _OnBoardingFirstViewState extends State<OnBoardingFirstView> {
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
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
      ),
    );
  }
}
