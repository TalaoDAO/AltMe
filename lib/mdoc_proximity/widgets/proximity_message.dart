import 'package:flutter/material.dart';

/// A spinner with a line of text.
class ProximityWaiting extends StatelessWidget {
  /// Creates the widget.
  const ProximityWaiting(this.text, {super.key});

  /// What is happening.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// An icon, a message, an optional detail and actions.
class ProximityMessage extends StatelessWidget {
  /// Creates the widget.
  const ProximityMessage({
    super.key,
    required this.icon,
    required this.text,
    this.detail,
    this.actions = const [],
  });

  /// The icon above the message.
  final IconData icon;

  /// The message.
  final String text;

  /// A smaller line under it, e.g. the platform error.
  final String? detail;

  /// Buttons, stacked.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, size: 64),
        const SizedBox(height: 16),
        Text(text, textAlign: TextAlign.center),
        if (detail != null) ...[
          const SizedBox(height: 8),
          Text(
            detail!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        for (final action in actions) ...[const SizedBox(height: 8), action],
      ],
    );
  }
}
