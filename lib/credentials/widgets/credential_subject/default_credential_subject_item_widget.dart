import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class DefaultCredentialSubjectItemWidget extends StatelessWidget {
  const DefaultCredentialSubjectItemWidget({Key? key, required this.model})
      : super(key: key);

  final DefaultCredentialSubjectModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CredentialField(value: model.type),
        CredentialField(value: model.issuedBy.name),
      ],
    );
  }
}
