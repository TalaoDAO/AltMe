import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class JsonViewerPage extends StatelessWidget {
  const JsonViewerPage({
    super.key,
    required this.title,
    required this.data,
    required this.showContinueButton,
  });

  final String title;
  final String data;
  final bool showContinueButton;

  static Route<dynamic> route({
    required String title,
    required String data,
    bool showContinueButton = false,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => JsonViewerPage(
          title: title,
          data: data,
          showContinueButton: showContinueButton,
        ),
        settings: const RouteSettings(name: '/JsonViewerPage'),
      );

  @override
  Widget build(BuildContext context) {
    return JsonViewerView(
      title: title,
      data: data,
      showContinueButton: showContinueButton,
    );
  }
}

class JsonViewerView extends StatelessWidget {
  const JsonViewerView({
    super.key,
    required this.title,
    required this.data,
    required this.showContinueButton,
  });

  final String title;
  final String data;
  final bool showContinueButton;

  @override
  Widget build(BuildContext context) {
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
      navigation: !showContinueButton
          ? null
          : Padding(
              padding: const EdgeInsets.all(
                Sizes.spaceSmall,
              ),
              child: MyElevatedButton(
                text: context.l10n.continueString,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
    );
  }
}
