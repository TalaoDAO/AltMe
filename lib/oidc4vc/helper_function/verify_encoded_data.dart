import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<VerificationType> verifyEncodedData({
  required String issuer,
  required JWTDecode jwtDecode,
  required String jwt,
  required bool useOAuthAuthorizationServerLink,
  Map<String, dynamic>? publicKeyJwk,
  bool fromStatusList = false,
  bool isCachingEnabled = false,
  bool isSdJwtVc = false,
}) async {
  final OIDC4VC oidc4vc = OIDC4VC();

  var updateJwt = jwt;

  if (updateJwt.contains('~')) {
    updateJwt = jwt.split('~').first;
  }

  final Map<String, dynamic> header = decodeHeader(
    jwtDecode: jwtDecode,
    token: updateJwt,
  );

  String? issuerKid;

  if (header.containsKey('kid')) {
    issuerKid = header['kid'].toString();
  }

  final VerificationType verificationType = await oidc4vc.verifyEncodedData(
    issuer: issuer,
    jwt: updateJwt,
    issuerKid: issuerKid,
    publicJwk: publicKeyJwk,
    fromStatusList: fromStatusList,
    isCachingEnabled: isCachingEnabled,
    dio: Dio(),
    useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
    isSdJwtVc: isSdJwtVc,
  );
  return verificationType;
}
