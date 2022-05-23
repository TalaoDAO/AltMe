import 'package:altme/app/shared/widget/base/markdown_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (context) => const PrivacyPage(),
      settings: const RouteSettings(name: '/privacyPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languagesList = ['fr', 'it', 'es', 'de'];
    var filePath = 'en';
    if (languagesList.contains(l10n.localeName)) {
      filePath = l10n.localeName;
    }
    return MarkdownPage(
      title: l10n.privacyTitle,
      file: 'assets/privacy/privacy_$filePath.md',
    );
  }
}
