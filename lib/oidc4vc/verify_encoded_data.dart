import 'package:altme/app/app.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<VerificationType> verifyEncodedData(
  String issuerDid,
  String issuerKid,
  String jwt,
) async {
  final VerificationType verificationType =
      await OIDC4VCType.EBSIV3.getOIDC4VC.verifyEncodedData(
    issuerDid: issuerDid,
    jwt: jwt,
    issuerKid: issuerKid,
  );
  return verificationType;
}
