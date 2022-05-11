import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';

class MarkdownPage extends StatelessWidget {
  MarkdownPage({Key? key, required this.title, required this.file})
      : super(key: key);

  final String title;
  final String file;

  final _log = Logger('altme/markdown_page');

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: EdgeInsets.zero,
      body: FutureBuilder<String>(
        future: _loadFile(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Markdown(
              data: snapshot.data!,
              styleSheet: MarkdownStyleSheet(
                h1: TextStyle(color: Theme.of(context).colorScheme.markDownH1),
                h2: TextStyle(color: Theme.of(context).colorScheme.markDownH2),
                a: TextStyle(color: Theme.of(context).colorScheme.markDownA),
                p: TextStyle(color: Theme.of(context).colorScheme.markDownP),
              ),
              onTapLink: (text, href, title) => _onTapLink(href),
            );
          }

          if (snapshot.error != null) {
            _log.severe(
              'something went wrong when loading $file',
              snapshot.error,
            );
            return Container();
          }

          return const Spinner();
        },
      ),
    );
  }

  Future<String> _loadFile() async {
    return rootBundle.loadString(file);
  }

  Future<void> _onTapLink(String? href) async {
    if (href == null) return;
    await LaunchUrl.launch(href);
  }
}
