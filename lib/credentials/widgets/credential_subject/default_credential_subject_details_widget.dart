import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class DefaultCredentialSubjectDetailsWidget extends StatelessWidget {
  const DefaultCredentialSubjectDetailsWidget({Key? key, required this.model})
      : super(key: key);

  final DefaultCredentialSubjectModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DisplayIssuer(
            issuer: model.issuedBy,
          ),
        ],
      ),
    );
  }
}
