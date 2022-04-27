import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';

class OnBoardingTosPage extends StatelessWidget {
  const OnBoardingTosPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingTosPage(),
        settings: const RouteSettings(name: '/onBoardingTermsPage'),
      );

  static final log = Logger('onboarding_tos_page');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: l10n.onBoardingTosTitle,
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
                      // Navigator.of(context)
                      //     .pushReplacement(ChooseWalletTypePage.route());
                    },
                    child: Text(l10n.onBoardingTosButton),
                  )
                ],
              ),
            ),
          ),
        ),
        body: displayTerms(context),
      ),
    );
  }

  FutureBuilder<String> displayTerms(BuildContext context) {
    final localizations = context.l10n;
    final String path;
    final languagesList = ['fr', 'it', 'es', 'de'];
    if (languagesList.contains(localizations.localeName)) {
      path = 'assets/privacy/privacy_${localizations.localeName}.md';
    } else {
      path = 'assets/privacy/privacy_en.md';
    }
    return FutureBuilder<String>(
      future: _loadFile(path),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Markdown(
            data: snapshot.data!,
            styleSheet: MarkdownStyleSheet(
              h1: TextStyle(color: Theme.of(context).colorScheme.markDownH1),
              h2: TextStyle(color: Theme.of(context).colorScheme.markDownH2),
              a: TextStyle(color: Theme.of(context).colorScheme.markDownA),
              p: TextStyle(color: Theme.of(context).colorScheme.markDownP),
              // onTapLink: (text, href, title) => _onTapLink(href),
            ),
          );
        }

        if (snapshot.error != null) {
          log.severe(
            'something went wrong when loading $path',
            snapshot.error,
          );
          return const SizedBox.shrink();
        }

        return const Spinner();
      },
    );
  }

  Future<String> _loadFile(String path) async {
    return rootBundle.loadString(path);
  }
}
