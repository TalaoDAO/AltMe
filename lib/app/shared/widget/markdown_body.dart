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
      data,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
