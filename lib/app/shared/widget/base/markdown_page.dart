import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownPage extends StatelessWidget {
  MarkdownPage({super.key, required this.title, required this.file});

  final String title;
  final String file;

  final log = getLogger('MarkdownPage');

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 0,
      ),
      body: BackgroundCard(
        padding: EdgeInsets.zero,
        child: FutureBuilder<String>(
          future: _loadFile(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Markdown(
                data: snapshot.data!,
                styleSheet: MarkdownStyleSheet(
                  h1: TextStyle(
                    color: Theme.of(context).colorScheme.markDownH1,
                  ),
                  h2: TextStyle(
                    color: Theme.of(context).colorScheme.markDownH2,
                  ),
                  a: TextStyle(color: Theme.of(context).colorScheme.markDownA),
                  p: TextStyle(color: Theme.of(context).colorScheme.markDownP),
                ),
                onTapLink: (text, href, title) => _onTapLink(href),
              );
            }

            if (snapshot.error != null) {
              log.e(
                'something went wrong when loading $file',
                snapshot.error,
              );
              return Container();
            }

            return const Spinner();
          },
        ),
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
