import 'package:altme/app/shared/widget/base/markdown_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const LicensesPage(),
        settings: const RouteSettings(name: '/licensePage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languagesList = ['fr', 'it', 'es', 'de'];
    var language = 'fr';
    if (languagesList.contains(l10n.localeName)) {
      language = l10n.localeName;
    }
    return MarkdownPage(
      title: l10n.licenses,
      file: 'assets/notices/notices_$language.md',
    );
  }
}
