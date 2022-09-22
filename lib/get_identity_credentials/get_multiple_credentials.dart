import 'dart:async';
import 'dart:convert';

import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

/// At the end of PassBase Process the wallet get identityAccessKey which
/// is used as preAuthorizedCode to get the identity credentials of the user.
/// That’s a 4 steps process:
/// 1/ Wallet get credential_manifest from https://issuer.talao.co/.well-known/openid-configuration
/// 2/ Wallet extract list of credential types from in the credential_manifest
/// 3/ After 5 minutes wallet ask a token to tokenEndPoint and provide preAuthorizedCode
/// 4/ For each credential type of the list, wallet is getting the credential from credentialEndPoint, providing accessToken and credentialType

Future<void> getMutipleCredentials(
  String preAuthorizedCode,
  DioClient client,
  WalletCubit walletCubit,
  secure_storage.SecureStorageProvider secureStorageProvider,
) async {
// TODO(all): getCredentialManifest()
// address of well_known containing credential manifest: https://issuer.talao.co/.well-known/openid-configuration
// TODO(all): getCredentialTypesList (credential manifest)
// first step, extract data from well_known. Currently that's hardcoded
// use jsonpath to handle this
  // record starting date in order to finish process on next phone start
  // if current thread had not finished properly
  await RegisterMultipleCredentialsProcess(
    secureStorageProvider,
    preAuthorizedCode,
  );
// Wait 5 minutes to let passbase verification time to happen
  Future.delayed(
      const Duration(
        minutes: Parameters.multipleCredentialsProcessDelay,
      ), () async {
    await getCredentialsFromIssuer(
      preAuthorizedCode,
      client,
      Parameters.credentialTypeList,
      secureStorageProvider,
      walletCubit,
    );
  });
}

Future<void> getCredentialsFromIssuer(
  String preAuthorizedCode,
  DioClient client,
  List<String> credentialTypeList,
  secure_storage.SecureStorageProvider secureStorageProvider,
  WalletCubit walletCubit,
) async {
  const String tokenEndPoint = 'https://issuer.talao.co/token';
  const String credentialEndPoint = 'https://issuer.talao.co/credential';
  // third step, get the access token from the issuer
  final dynamic accessTokenAndNonce =
      await getAccessTokenAndNonce(tokenEndPoint, preAuthorizedCode, client);
  final dynamic data = accessTokenAndNonce is String
      ? jsonDecode(accessTokenAndNonce)
      : accessTokenAndNonce;
  final String accessToken = data['access_token'] as String;
  final String nonce = data['c_nonce'] as String;

  for (final type in credentialTypeList) {
    final dynamic credential = await getCredential(
      accessToken,
      nonce,
      credentialEndPoint,
      type,
      client,
      secureStorageProvider,
    );

    // prepare credential for insertion
    if (credential != null) {
      final Map<String, dynamic> newCredential =
          Map<String, dynamic>.from(credential as Map<String, dynamic>);
      newCredential['credentialPreview'] = credential;

      final credentialModel = CredentialModel.copyWithData(
        oldCredentialModel: CredentialModel.fromJson(
          newCredential,
        ),
        newData: credential,
        activities: [Activity(acquisitionAt: DateTime.now())],
      );
      // insert the credential in the wallet
      await walletCubit.insertCredential(credentialModel);
    }
  }
  unawaited(UnregisterMultipleCredentialsProcess(secureStorageProvider));
}

Future<dynamic> getCredential(
  String accessToken,
  String nonce,
  String credentialEndPoint,
  String type,
  DioClient client,
  secure_storage.SecureStorageProvider secureStorageProvider,
) async {
  try {
    final did = (await secureStorageProvider.get(SecureStorageKeys.did))!;
    // const did = 'did:key:z6Mkmtke1zQpoa21FnkHobmfMPw478SzLkRj9ZTujaFRg39u';

    /// If credential manifest exist we follow instructions to present
    /// credential
    /// If credential manifest doesn't exist we add DIDAuth to the post
    /// If id was in preview we send it in the post
    ///  https://github.com/TalaoDAO/wallet-interaction/blob/main/README.md#credential-offer-protocol
    ///
    final key = (await secureStorageProvider.get(SecureStorageKeys.ssiKey))!;
    // const key =
    // ignore: lines_longer_than_80_chars
    //     '{"kty":"OKP","crv":"Ed25519","d":"g6lh_xxgQyoconYGSbsiJut9EoKiq0_3E0EKK1z4MQE=","x":"bomo2KEz8xbRzuckXmQW17WJzUWHAolOUF54SYRB_-Q="}';
    // final verificationMethod =
    // ignore: lines_longer_than_80_chars
    //     'did:key:z6Mkmtke1zQpoa21FnkHobmfMPw478SzLkRj9ZTujaFRg39u#z6Mkmtke1zQpoa21FnkHobmfMPw478SzLkRj9ZTujaFRg39u';
    final verificationMethod =
        await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

    final options = <String, dynamic>{
      'verificationMethod': verificationMethod,
      'proofPurpose': 'authentication',
      'challenge': nonce,
      'domain': 'issuer.talao.co',
    };

    final DIDKitProvider didKitProvider = DIDKitProvider();
    final String did_auth = await didKitProvider.didAuth(
      did,
      jsonEncode(options),
      key,
    );
    final dynamic response = await client.post(
      credentialEndPoint,
      headers: <String, dynamic>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      data: <String, dynamic>{
        'type': type,
        'format': 'ldp_vc',
        'did': did,
        'proof': {'proof_type': 'ldp_vp', 'vp': did_auth}
      },
    );
    return jsonDecode(response['credential'] as String);
  } catch (e) {
    throw Exception();
  }
}

Future<dynamic> getAccessTokenAndNonce(
  String tokenEndPoint,
  String preAuthorizedCode,
  DioClient client,
) async {
  try {
    final dynamic accessTokenAndNonce = await client.post(
      'https://issuer.talao.co/token',
      headers: <String, dynamic>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer mytoken',
        'X-API-KEY': '99999-99999-99999',
      },
      data: <String, dynamic>{
        'pre-authorized_code': preAuthorizedCode,
        'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
      },
    );
    return accessTokenAndNonce;
  } catch (e) {
    throw Exception();
  }
}

Future<void> RegisterMultipleCredentialsProcess(
  secure_storage.SecureStorageProvider secureStorageProvider,
  String preAuthorizedCode,
) async {
  await secureStorageProvider.set(
    SecureStorageKeys.passBaseVerificationDate,
    DateTime.now().toString(),
  );
  await secureStorageProvider.set(
    SecureStorageKeys.preAuthorizedCode,
    preAuthorizedCode,
  );
}

Future<void> UnregisterMultipleCredentialsProcess(
  secure_storage.SecureStorageProvider secureStorageProvider,
) async {
  await secureStorageProvider.set(
    SecureStorageKeys.passBaseVerificationDate,
    '',
  );
}

Future<bool> isGettingMultipleCredentialsNeeded(
  secure_storage.SecureStorageProvider secureStorageProvider,
) async {
  final String? passBaseVerificationDate = await secureStorageProvider.get(
    SecureStorageKeys.passBaseVerificationDate,
  );
  if (passBaseVerificationDate != null && passBaseVerificationDate != '') {
    final DateTime date = DateTime.parse(passBaseVerificationDate);
    final DateTime now = DateTime.now();
    final Duration timeDifference = now.difference(date);
    if (timeDifference.inMinutes > Parameters.multipleCredentialsProcessDelay) {
      return true;
    }
  }
  return false;
}
