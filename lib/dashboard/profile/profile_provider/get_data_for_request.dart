import 'dart:convert';

import 'package:altme/app/shared/constants/parameters.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:altme/dashboard/profile/models/profile.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

Future<Map<String, dynamic>> getDataForRequest({
  required String nonce,
  required SecureStorageProvider secureStorageProvider,
  required ProfileModel profileModel,
}) async {
  /// get private key
  final p256KeyForWallet =
      await getWalletAttestationP256Key(secureStorageProvider);
  final privateKey = jsonDecode(p256KeyForWallet) as Map<String, dynamic>;

  final customOidc4vcProfile = profileModel
      .profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;

  final tokenParameters = TokenParameters(
    privateKey: privateKey,
    did: '',
    kid: null,
    mediaType: MediaType.walletAttestation,
    clientType: customOidc4vcProfile.clientType,
    proofHeaderType: customOidc4vcProfile.proofHeader,
    clientId: customOidc4vcProfile.clientId ?? '',
  );

  final thumbPrint = tokenParameters.thumbprint;

  final publicJWKString = sortedPublcJwk(p256KeyForWallet);
  final publicJWK = jsonDecode(publicJWKString) as Map<String, dynamic>;

  final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  final payload = {
    'iss': thumbPrint,
    'wallet': Parameters.appName.toLowerCase(),
    'aud': 'https://wallet-provider.altme.io',
    'jti': const Uuid().v4(),
    'nonce': nonce,
    'cnf': {
      'jwk': {
        ...publicJWK,
        'kid': thumbPrint,
      },
    },
    'iat': iat,
    'exp': iat + 1000,
  };

  /// sign and get token
  final jwtToken = generateToken(
    payload: payload,
    tokenParameters: tokenParameters,
  );

  final data = {
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'assertion': jwtToken,
  };
  return data;
}
