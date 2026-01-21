import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/dashboard/profile/models/models.dart';
import 'package:altme/dashboard/profile/profile_provider/get_data_for_request.dart';
import 'package:altme/dashboard/profile/profile_provider/get_nonce.dart';
import 'package:altme/oidc4vc/helper_function/verify_encoded_data.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

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
  final issuerKid = header['kid'].toString();
  final did = issuerKid.split('#')[0];

  /// verify
  final VerificationType isVerified = await verifyEncodedData(
    issuer: did,
    jwtDecode: jwtDecode,
    jwt: jwtVc,
    useOAuthAuthorizationServerLink: useOauthServerAuthEndPoint(profileModel),
  );

  if (isVerified != VerificationType.verified) {
    throw ResponseMessage(
      message: ResponseString.RESPONSE_STRING_invalidStatus,
    );
  }

  final payload = jwtDecode.parseJwt(jwtVc);
  final status = payload['status'];

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
