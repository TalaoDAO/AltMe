import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class HostPromptHandler extends StatelessWidget {
  const HostPromptHandler({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    required this.yesLabel,
    required this.noLabel,
    this.invertedCallToAction = false,
  });
  final String title;
  final String? subtitle;
  final Widget? content;
  final String yesLabel;
  final String noLabel;
  final bool invertedCallToAction;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConfirmDialog(
        title: title,
        subtitle: subtitle,
        content: content,
        yes: yesLabel,
        no: noLabel,
        invertedCallToAction: invertedCallToAction,
      ),
    );
  }
}
