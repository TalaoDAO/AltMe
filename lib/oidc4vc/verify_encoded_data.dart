import 'package:altme/app/app.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<VerificationType> verifyEncodedData({
  required String issuer,
  required JWTDecode jwtDecode,
  required String jwt,
}) async {
  final OIDC4VC oidc4vc = OIDC4VC();

  var updateJwt = jwt;

  if (updateJwt.contains('~')) {
    updateJwt = jwt.split('~').first;
  }

  final Map<String, dynamic> header =
      decodeHeader(jwtDecode: jwtDecode, token: updateJwt);

  String? issuerKid;

  if (header.containsKey('kid')) {
    issuerKid = header['kid'].toString();
  }

  Map<String, dynamic>? publicJwk;

  if (header.containsKey('jwk')) {
    final jwk = header['jwk'];

    if (jwk is Map<String, dynamic>) {
      publicJwk = jwk;
    }
  }

  final VerificationType verificationType = await oidc4vc.verifyEncodedData(
    issuer: issuer,
    jwt: updateJwt,
    issuerKid: issuerKid,
    publicJwk: publicJwk,
  );
  return verificationType;
}
