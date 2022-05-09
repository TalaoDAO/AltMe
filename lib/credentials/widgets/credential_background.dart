import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialBackground extends StatelessWidget {
  const CredentialBackground({
    Key? key,
    required this.model,
    required this.child,
  }) : super(key: key);

  final CredentialModel model;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
        decoration: BaseBoxDecoration(
          color: model.backgroundColor,
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 0,
          shapeSize: 256,
          anchors: const <Alignment>[
            Alignment.topRight,
            Alignment.bottomCenter,
          ],
          // value: animation.value,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
