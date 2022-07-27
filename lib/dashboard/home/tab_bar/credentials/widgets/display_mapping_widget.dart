import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class DisplayMappingWidget extends StatelessWidget {
  const DisplayMappingWidget({
    this.displayMapping,
    required this.credentialModel,
    required this.style,
    Key? key,
  }) : super(key: key);
  final DisplayMapping? displayMapping;
  final CredentialModel credentialModel;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;
    if (object is DisplayMappingText) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ManifestText2(
          text: object.text,
          style: style,
        ),
      );
    }
    if (object is DisplayMappingPath) {
      final widgets = <Widget>[];
      for (final e in object.path) {
        final textList = getTextsFromCredential(e, credentialModel.data);
        for (final element in textList) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.all(8),
              child: ManifestText2(text: element, style: style),
            ),
          );
        }
      }

      if (widgets.isNotEmpty) {
        return Column(
          children: widgets,
        );
      }
      if (object.fallback != null) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: ManifestText2(
            text: object.fallback ?? '',
            style: style,
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}

class ManifestText2 extends StatelessWidget {
  const ManifestText2({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: 5,
      overflow: TextOverflow.fade,
      softWrap: true,
    );
  }
}
