import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class OnBoardingTosPage extends StatelessWidget {
  const OnBoardingTosPage({Key? key, required this.routeTo}) : super(key: key);

  final Route routeTo;

  static Route route({required Route routeTo}) => MaterialPageRoute<void>(
        builder: (context) => OnBoardingTosPage(routeTo: routeTo),
        settings: const RouteSettings(name: '/onBoardingTermsPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: l10n.onBoardingTosTitle,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: EdgeInsets.zero,
      useSafeArea: false,
      navigation: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(-1, -1),
              blurRadius: 4,
            ),
          ],
        ),
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
                Text(
                  l10n.onBoardingTosText,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20),
                BaseButton.primary(
                  context: context,
                  onPressed: () {
                    Navigator.of(context).push<void>(routeTo);
                  },
                  child: Text(l10n.onBoardingTosButton),
                )
              ],
            ),
          ),
        ),
      ),
      body: const DisplayTerms(),
    );
  }
}
