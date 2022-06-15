import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialBackground extends StatelessWidget {
  const CredentialBackground({
    Key? key,
    required this.credentialModel,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
        decoration: BaseBoxDecoration(
          color: backgroundColor ??
              credentialModel.credentialPreview.credentialSubjectModel
                  .credentialSubjectType
                  .backgroundColor(credentialModel),
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 0,
          shapeSize: 256,
          anchors: const <Alignment>[
            Alignment.topRight,
            Alignment.bottomCenter,
          ],
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
