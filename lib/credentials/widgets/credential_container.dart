import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialContainer extends StatelessWidget {
  const CredentialContainer({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.documentShadow,
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }
}
