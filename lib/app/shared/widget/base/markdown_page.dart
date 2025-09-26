import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

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
              return GptMarkdown(
                snapshot.data!,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              );
            }

            if (snapshot.error != null) {
              log.e(
                'something went wrong when loading $file',
                error: snapshot.error,
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
}
