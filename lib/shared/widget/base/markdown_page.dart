import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';
import 'package:ssi_crypto_wallet/shared/widget/back_leading_button.dart';
import 'package:ssi_crypto_wallet/shared/widget/base/page.dart';
import 'package:ssi_crypto_wallet/shared/widget/spinner.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownPage extends StatelessWidget {
  MarkdownPage({Key? key, required this.title, required this.file})
      : super(key: key);

  final String title;
  final String file;

  final _log = Logger('credible/markdown_page');

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
                h1: TextStyle(color: Theme.of(context).colorScheme.primary),
                h2: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
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

    if (await canLaunch(href)) {
      await launch(href);
    } else {
      _log.severe('cannot launch url: $href');
    }
  }
}
