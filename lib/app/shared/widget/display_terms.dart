import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';

class DisplayTerms extends StatefulWidget {
  const DisplayTerms({Key? key}) : super(key: key);

  @override
  State<DisplayTerms> createState() => _DisplayTermsState();
}

class _DisplayTermsState extends State<DisplayTerms> {
  late String path;

  final log = Logger('onboarding_tos_page');

  void setPath(String localeName) {
    final languagesList = ['fr', 'it', 'es', 'de'];
    if (languagesList.contains(localeName)) {
      path = 'assets/privacy/privacy_$localeName.md';
    } else {
      path = 'assets/privacy/privacy_en.md';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    setPath(l10n.localeName);
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
