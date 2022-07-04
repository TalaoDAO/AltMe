import 'package:altme/app/shared/widget/base/markdown_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

// TODO(bibash): PageView
class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const TermsPage(),
        settings: const RouteSettings(name: '/termsPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languagesList = ['fr', 'it', 'es', 'de'];
    var language = 'en';
    if (languagesList.contains(l10n.localeName)) {
      language = l10n.localeName;
    }
    return MarkdownPage(
      title: l10n.onBoardingTosTitle,
      file: 'assets/terms/mobile_cgu_$language.md',
    );
  }
}
