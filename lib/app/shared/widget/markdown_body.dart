import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class MarkdownBody extends StatelessWidget {
  const MarkdownBody({
    super.key,
    this.physics,
    this.shrinkWrap = true,
    required this.data,
  });

  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final String data;

  @override
  Widget build(BuildContext context) {
    return GptMarkdown(
      onLinkTap: (url, title) {
        LaunchUrl.launch(url);
      },
      linkBuilder: (context, label, path, style) {
        return Text.rich(label, style: style.copyWith(color: Colors.blue));
      },
      data,
      style: const TextStyle(),
    );
  }
}
