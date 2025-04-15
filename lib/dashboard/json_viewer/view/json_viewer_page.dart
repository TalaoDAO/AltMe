import 'package:altme/ai/widget/ai_analysis_button.dart';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class JsonViewerPage extends StatelessWidget {
  const JsonViewerPage({
    super.key,
    required this.title,
    required this.data,
    required this.showButton,
    this.uri,
  });

  final String title;
  final String data;
  final bool showButton;
  final Uri? uri;

  static Route<dynamic> route({
    required String title,
    required String data,
    bool showButton = true,
    Uri? uri,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => JsonViewerPage(
          title: title,
          data: data,
          showButton: showButton,
          uri: uri,
        ),
        settings: const RouteSettings(name: '/JsonViewerPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: title,
      titleAlignment: Alignment.topCenter,
      scrollView: true,
      titleLeading: BackLeadingButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      body: JsonViewWidget(data: data),
      navigation: !showButton
          ? null
          : Padding(
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
                    },
                  ),
                  const SizedBox(height: 8),
                  MyElevatedButton(
                    text: l10n.download,
                    verticalSpacing: 14,
                    fontSize: 15,
                    elevation: 0,
                    onPressed: () {
                      final box = context.findRenderObject() as RenderBox?;
                      final subject = l10n.shareWith;

                      Share.share(
                        data,
                        subject: subject,
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size,
                      );
                    },
                  ),
                  if (uri != null)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        AiAnalysisButton(
                          link: uri!.toString(),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }
}
