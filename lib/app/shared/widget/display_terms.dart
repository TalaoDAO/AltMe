import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';

class DisplayTermsofUse extends StatefulWidget {
  const DisplayTermsofUse({
    Key? key,
    this.physics,
    this.shrinkWrap = true,
  }) : super(key: key);

  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  State<DisplayTermsofUse> createState() => _DisplayTermsofUseState();
}

class _DisplayTermsofUseState extends State<DisplayTermsofUse> {
  late String privacyPath;
  late String termsPath;

  final log = Logger('onboarding_tos_page');

  void setPath(String localeName) {
    final languagesList = ['fr', 'it', 'es', 'de'];
    var language = 'en';
    if (languagesList.contains(localeName)) {
      language = localeName;
    }
    privacyPath = 'assets/privacy/privacy_$language.md';
    termsPath = 'assets/terms/mobile_cgu_$language.md';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    setPath(l10n.localeName);
    return Column(
      children: [
        /// Privacry Policy
        FutureBuilder<String>(
          future: _loadFile(privacyPath),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return MarkdownBody(
                physics: widget.physics,
                shrinkWrap: widget.shrinkWrap,
                data: snapshot.data!,
              );
            }

            if (snapshot.error != null) {
              log.severe(
                'something went wrong when loading $privacyPath',
                snapshot.error,
              );
              return const SizedBox.shrink();
            }

            return const Spinner();
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        ),

        /// Terms
        FutureBuilder<String>(
          future: _loadFile(termsPath),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return MarkdownBody(
                physics: widget.physics,
                shrinkWrap: widget.shrinkWrap,
                data: snapshot.data!,
              );
            }

            if (snapshot.error != null) {
              log.severe(
                'something went wrong when loading $termsPath',
                snapshot.error,
              );
              return const SizedBox.shrink();
            }

            return const Spinner();
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Future<String> _loadFile(String path) async {
    return rootBundle.loadString(path);
  }
}

class MarkdownBody extends StatelessWidget {
  const MarkdownBody({
    Key? key,
    this.physics,
    this.shrinkWrap = true,
    required this.data,
  }) : super(key: key);

  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      physics: physics,
      shrinkWrap: shrinkWrap,
      data: data,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(
          color: Theme.of(context).colorScheme.markDownH1,
        ),
        h2: TextStyle(color: Theme.of(context).colorScheme.markDownH2),
        a: TextStyle(color: Theme.of(context).colorScheme.markDownA),
        p: TextStyle(color: Theme.of(context).colorScheme.markDownP),

        //onTapLink: (text, href, title) => _onTapLink(href),
      ),
    );
  }
}
