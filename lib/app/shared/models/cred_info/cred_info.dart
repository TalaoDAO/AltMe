import 'package:altme/app/app.dart';
import 'package:oidc4vc/oidc4vc.dart';

class CredInfo {
  CredInfo({
    required this.credentialType,
    required this.formatType,
  });

  final CredentialSubjectType credentialType;
  final VCFormatType formatType;
}
