import 'package:altme/app/shared/widget/base/markdown_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const NoticesPage(),
        settings: const RouteSettings(name: '/noticesPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MarkdownPage(title: l10n.noticesTitle, file: 'assets/notices.md');
  }
}
