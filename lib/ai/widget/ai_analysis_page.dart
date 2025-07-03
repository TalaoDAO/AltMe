import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/markdown_body.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AiAnalysisPage extends StatelessWidget {
  const AiAnalysisPage({
    super.key,
    required this.content,
  });

  final String content;

  static Route<dynamic> route({
    required String content,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => AiAnalysisPage(
          content: content,
        ),
        settings: const RouteSettings(name: '/AiAnalysisPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = String.fromCharCodes(base64Decode(content));
    return BasePage(
      title: l10n.iaAnalyzeTitle,
      titleAlignment: Alignment.topCenter,
      scrollView: true,
      titleLeading: BackLeadingButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      body: SingleChildScrollView(
        child: MarkdownBody(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          data: data,
        ),
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(
          Sizes.spaceSmall,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyElevatedButton(
              text: l10n.continueString,
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
