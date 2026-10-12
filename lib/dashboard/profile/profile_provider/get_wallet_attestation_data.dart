import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/dashboard/profile/models/models.dart';
import 'package:altme/dashboard/profile/profile_provider/get_data_for_request.dart';
import 'package:altme/dashboard/profile/profile_provider/get_nonce.dart';
import 'package:altme/oidc4vc/helper_function/verify_encoded_data.dart';
import 'package:asn1lib/asn1lib.dart' as asn1lib;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:x509_plus/x509.dart' as x509;

/// Gets wallet attestation data from the wallet provider
///
/// This method fetches a nonce, gets data for the request,
/// makes a POST request to get the credential, verifies it,
/// and checks the status list to ensure the wallet is not suspended.
Future<String> getWalletAttestationData({
  required String url,
  required DioClient client,
  required SecureStorageProvider secureStorageProvider,
  required ProfileModel profileModel,
  required JWTDecode jwtDecode,
}) async {
  /// GET nonce
  final nonce = await getNonce(url: url, client: client);

  /// get data to send to attestation request
  final Map<String, dynamic> data = await getDataForRequest(
    nonce: nonce,
    secureStorageProvider: secureStorageProvider,
    profileModel: profileModel,
  );

  /// get vc
  final response = await client.post(
    '$url/token',
    headers: <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    data: data,
  );

  final jwtVc = response.toString();

  /// parse
  final header = jwtDecode.parseJwtHeader(jwtVc);
  final payload = jwtDecode.parseJwt(jwtVc);
  final x5c = header['x5c'];

  /// verify: the standard Wallet Instance Attestation is signed with the key
  /// of its `x5c` leaf certificate; the older one with a DID, named by `kid`.
  final VerificationType isVerified = x5c is List && x5c.isNotEmpty
      ? await verifyEncodedData(
          issuer: payload['iss'].toString(),
          jwtDecode: jwtDecode,
          jwt: jwtVc,
          publicKeyJwk: leafCertificateJwk(x5c.first.toString()),
          useOAuthAuthorizationServerLink: useOauthServerAuthEndPoint(
            profileModel,
          ),
        )
      : await verifyEncodedData(
          issuer: header['kid'].toString().split('#')[0],
          jwtDecode: jwtDecode,
          jwt: jwtVc,
          useOAuthAuthorizationServerLink: useOauthServerAuthEndPoint(
            profileModel,
          ),
        );

  if (isVerified != VerificationType.verified) {
    throw ResponseMessage(
      message: ResponseString.RESPONSE_STRING_invalidStatus,
    );
  }

  // The standard attestation carries its status under `client_status`.
  final clientStatus = payload['client_status'];
  final status =
      payload['status'] ??
      (clientStatus is Map<String, dynamic> ? clientStatus['status'] : null);

  if (status != null && status is Map<String, dynamic>) {
    final statusList = status['status_list'];
    if (statusList != null && statusList is Map<String, dynamic>) {
      final uri = statusList['uri'];
      final idx = statusList['idx'];

      if (idx != null && idx is int && uri != null && uri is String) {
        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/statuslist+jwt',
        };

        final response = await client.get(
          uri,
          headers: headers,
          options: Options().copyWith(
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

        final payload = jwtDecode.parseJwt(response.toString());

        /// verify the signature of the VC with the kid of the JWT
        final VerificationType isVerified = await verifyEncodedData(
          issuer: payload['iss'].toString(),
          jwtDecode: jwtDecode,
          jwt: response.toString(),
          fromStatusList: true,
          useOAuthAuthorizationServerLink: useOauthServerAuthEndPoint(
            profileModel,
          ),
        );

        if (isVerified != VerificationType.verified) {
          throw ResponseMessage(
            message: ResponseString.RESPONSE_STRING_statusListInvalidSignature,
          );
        }

        final newStatusList = payload['status_list'];
        if (newStatusList != null && newStatusList is Map<String, dynamic>) {
          final lst = newStatusList['lst'].toString();

          final bit = getBit(index: idx, encodedList: lst);

          if (bit == 0) {
            // active
          } else {
            // revoked
            throw ResponseMessage(
              message: ResponseString.RESPONSE_STRING_theWalletIsSuspended,
            );
          }
        }
      }
    }
  }

  await secureStorageProvider.set(
    SecureStorageKeys.walletAttestationData,
    jwtVc,
  );

  return jwtVc;
}

/// The public P-256 JWK of the base64 DER [certificate].
@visibleForTesting
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
