import 'package:flutter/material.dart';

class CredentialSelectionPadding extends StatelessWidget {
  const CredentialSelectionPadding({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: child,
    );
  }
}
