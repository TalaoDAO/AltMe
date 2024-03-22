import 'package:oidc4vc/oidc4vc.dart';

Future<VerificationType> verifyEncodedData(
  String issuerDid,
  String? issuerKid,
  String jwt,
) async {
  final OIDC4VC oidc4vc = OIDC4VC();

  var updateJwt = jwt;

  if (updateJwt.contains('~')) {
    updateJwt = jwt.split('~').first;
  }

  final VerificationType verificationType = await oidc4vc.verifyEncodedData(
    issuerDid: issuerDid,
    jwt: updateJwt,
    issuerKid: issuerKid,
  );
  return verificationType;
}
