import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
    return Markdown(
      physics: physics,
      shrinkWrap: shrinkWrap,
      data: data,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        h2: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        a: TextStyle(color: Theme.of(context).colorScheme.primary),
        p: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),

        //onTapLink: (text, href, title) => _onTapLink(href),
      ),
    );
  }
}
