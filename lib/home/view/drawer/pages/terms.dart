import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ssi_crypto_wallet/shared/widget/base/markdown_page.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder<void>(
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) =>
          const TermsPage(),
      settings: const RouteSettings(name: '/terms'),
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // ignore: prefer_int_literals
        const begin = 0.0;
        const end = 1.0;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return FadeTransition(opacity: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languagesList = ['fr', 'it', 'es', 'de'];
    var filePath = 'en';
    if (languagesList.contains(localizations.localeName)) {
      filePath = localizations.localeName;
    }
    return MarkdownPage(
      title: localizations.onBoardingTosTitle,
      file: 'assets/terms/mobile_cgu_$filePath.md',
    );
  }
}
