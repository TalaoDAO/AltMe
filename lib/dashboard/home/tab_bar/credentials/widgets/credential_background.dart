import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialBackground extends StatelessWidget {
  const CredentialBackground({
    super.key,
    this.showBgDecoration = true,
    required this.credentialModel,
    required this.child,
    this.backgroundColor,
  });

  final bool showBgDecoration;
  final CredentialModel credentialModel;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: DecoratedBox(
        decoration: BaseBoxDecoration(
          color: backgroundColor ??
              credentialModel.credentialPreview.credentialSubjectModel
                  .credentialSubjectType
                  .backgroundColor(credentialModel),
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 0,
          shapeSize: 256,
          anchors: showBgDecoration
              ? const <Alignment>[
                  Alignment.topRight,
                  Alignment.bottomCenter,
                ]
              : <Alignment>[],
          // value: animation.value,
          borderRadius: BorderRadius.circular(Sizes.credentialBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}
