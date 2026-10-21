import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:asn1lib/asn1lib.dart' as asn1lib;
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:x509_plus/x509.dart' as x509;

Future<VerificationType> verifyEncodedData({
  required String issuer,
  required JWTDecode jwtDecode,
  required String jwt,
  required bool useOAuthAuthorizationServerLink,
  Map<String, dynamic>? publicKeyJwk,
  bool fromStatusList = false,
  bool isCachingEnabled = false,
  bool isSdJwtVc = false,
  Dio? dio,
}) async {
  final oidc4vc = Oidc4vciClientFactory.create(OIDC4VCIDraftType.final1);

  var updateJwt = jwt;

  if (updateJwt.contains('~')) {
    updateJwt = jwt.split('~').first;
  }

  final Map<String, dynamic> header = jwtDecode.decodeHeader(token: updateJwt);

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
    dio: dio ?? Dio(),
    useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
    isSdJwtVc: isSdJwtVc,
  );
  return verificationType;
}

/// Verifies a Status List Token as draft-ietf-oauth-status-list §11.3
/// recommends: a Status Issuer that also issued the Referenced Token may sign
/// the Status List Token with the same key, so [referencedTokenKey] is tried
/// first, whatever `kid` the Status List Token names. Otherwise the key is
/// looked up from the Status List Token's [issuer], as before.
Future<VerificationType> verifyStatusListToken({
  required String statusListToken,
  required String issuer,
  required JWTDecode jwtDecode,
  required bool useOAuthAuthorizationServerLink,
  Map<String, dynamic>? referencedTokenKey,
  bool isCachingEnabled = false,
  Dio? dio,
}) async {
  if (referencedTokenKey != null) {
    try {
      final verification = await verifyEncodedData(
        issuer: issuer,
        jwtDecode: jwtDecode,
        jwt: statusListToken,
        // Without its own kid: the Status List Token may name the key
        // otherwise.
        publicKeyJwk: Map.of(referencedTokenKey)..remove('kid'),
        fromStatusList: true,
        useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
        dio: dio,
      );
      if (verification == VerificationType.verified) return verification;
    } on Exception {
      // Not signed with this key: look the key up below.
    }
  }
  return verifyEncodedData(
    issuer: issuer,
    jwtDecode: jwtDecode,
    jwt: statusListToken,
    fromStatusList: true,
    isCachingEnabled: isCachingEnabled,
    useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
    dio: dio,
  );
}

/// The P-256 key of the leaf certificate in the `x5c` header of [jwt] (an
/// SD-JWT is read up to its first `~`), or null when there is none.
Map<String, dynamic>? x5cLeafKey({
  required String jwt,
  required JWTDecode jwtDecode,
}) {
  final header = jwtDecode.decodeHeader(token: jwt.split('~').first);
  final x5c = header['x5c'];
  if (x5c is! List || x5c.isEmpty) return null;
  try {
    return leafCertificateJwk(x5c.first.toString());
  } on ResponseMessage {
    return null;
  }
}

/// The public P-256 JWK of the base64 DER [certificate].
Map<String, dynamic> leafCertificateJwk(String certificate) {
  final cert = x509.X509Certificate.fromAsn1(
    asn1lib.ASN1Sequence.fromBytes(base64Decode(certificate)),
  );
  final key = cert.publicKey;
  if (key is! x509.EcPublicKey) {
    throw ResponseMessage(
      message: ResponseString.RESPONSE_STRING_invalidStatus,
    );
  }
  String coordinate(Object value) {
    var rest = BigInt.parse(value.toString());
    final bytes = List<int>.filled(32, 0);
    for (var i = 31; i >= 0; i--) {
      bytes[i] = (rest & BigInt.from(0xff)).toInt();
      rest = rest >> 8;
    }
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  return {
    'kty': 'EC',
    'crv': 'P-256',
    'x': coordinate(key.xCoordinate),
    'y': coordinate(key.yCoordinate),
  };
}
