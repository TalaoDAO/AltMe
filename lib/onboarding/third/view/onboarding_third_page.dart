import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/tos/view/onboarding_tos_page.dart';
import 'package:flutter/material.dart';

class OnBoardingThirdPage extends StatefulWidget {
  const OnBoardingThirdPage({Key? key}) : super(key: key);

  static Route route() => RightToLeftRoute<void>(
        builder: (context) => const OnBoardingThirdPage(),
        settings: const RouteSettings(name: '/onBoardingThirdPage'),
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
      key: const Key('third_page_gesture_detector'),
      onHorizontalDragUpdate: (drag) async {
        if (animate && drag.delta.dx > 2) {
          Navigator.of(context).pop();
          disableAnimation();
        }
      },
      child: BasePage(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrollView: true,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/image/slide_3.png',
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                l10n.appPresentation3,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
        navigation: Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.2),
                          size: 15,
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.circle,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.2),
                          size: 15,
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.circle,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  BaseButton.primary(
                    context: context,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      Navigator.of(context).pushReplacement<void, void>(
                        OnBoardingTosPage.route(),
                      );
                    },
                    child: Text(l10n.onBoardingStartButton),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
