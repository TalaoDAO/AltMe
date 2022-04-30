import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:flutter/material.dart';

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final CredentialModel model;

  @override
  Widget build(BuildContext context) {
    return model.credentialPreview.credentialSubject.displayDetail(
      context,
      model,
    );
  }
}
