import 'package:dio/dio.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<VerificationType> verifyEncodedData(
  String issuerDid,
  String issuerKid,
  String jwt,
) async {
  final OIDC4VC oidc4vc = OIDC4VC(Dio());

  final VerificationType verificationType = await oidc4vc.verifyEncodedData(
    issuerDid: issuerDid,
    jwt: jwt,
    issuerKid: issuerKid,
  );
  return verificationType;
}
