import 'package:altme/app/shared/widget/base/markdown_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (_) => const SupportPage(),
        settings: const RouteSettings(name: '/supportPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MarkdownPage(
      title: l10n.supportTitle,
      file: 'assets/support.md',
    );
  }
}
