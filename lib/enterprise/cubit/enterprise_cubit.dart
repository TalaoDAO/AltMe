import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';

part 'enterprise_cubit.g.dart';

part 'enterprise_state.dart';

class EnterpriseCubit extends Cubit<EnterpriseState> {
  EnterpriseCubit({
    required this.client,
    required this.jwtDecode,
    required this.profileCubit,
    required this.walletCubit,
  }) : super(const EnterpriseState());

  final DioClient client;
  final JWTDecode jwtDecode;
  final ProfileCubit profileCubit;
  final WalletCubit walletCubit;

  Future<void> requestTheConfiguration(Uri uri) async {
    try {
      emit(state.loading());

      final String? email = uri.queryParameters['login'];
      final String? password = uri.queryParameters['password'];
      final String? url = uri.queryParameters['wallet-provider'];

      if (email == null || password == null || url == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description':
                'The email or password or provider is missing.',
          },
        );
      }

      final savedEmail = await profileCubit.secureStorageProvider.get(
        SecureStorageKeys.enterpriseEmail,
      );

      // if (savedEmail != null) {
      //   if (email == savedEmail) {
      //     /// if email is matched then update the configuration
      //     await updateTheConfiguration();
      //     return;
      //   } else {
      //     throw ResponseMessage(
      //       message:
      //           ResponseString.RESPONSE_STRING_thisWalleIsAlreadyConfigured,
      //     );
      //   }
      // }

      if (savedEmail != null) {
        throw ResponseMessage(
          message: ResponseString.RESPONSE_STRING_thisWalleIsAlreadyConfigured,
        );
      }

      /// get vc and store it in the wallet
      final walletAttestationData = await getWalletAttestationData(url);

      /// request the configuration and verify
      await verifyAndGetConfiguration(
        email: email,
        password: password,
        jwtVc: walletAttestationData,
        url: url,
      );

      /// save data
      await profileCubit.secureStorageProvider
          .set(SecureStorageKeys.enterpriseEmail, email);

      await profileCubit.secureStorageProvider
          .set(SecureStorageKeys.enterprisePassword, password);

      await profileCubit.secureStorageProvider
          .set(SecureStorageKeys.enterpriseWalletProvider, url);

      /// uprade wallet to enterprise
      await profileCubit.setWalletType(
        walletType: WalletType.enterprise,
      );

      // if enterprise and walletAttestation data is available and added
      await walletCubit.credentialsCubit.addWalletCredential(
        blockchainType: walletCubit.state.currentAccount?.blockchainType,
      );

      emit(
        state.copyWith(
          message: StateMessage.success(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_successfullyAddedEnterpriseAccount,
            ),
          ),
        ),
      );
    } catch (e) {
      emitError(e);
    }
  }

  Future<void> verifyAndGetConfiguration({
    required String email,
    required String password,
    required String jwtVc,
    required String url,
  }) async {
    /// request the configuration
    final encodedData = utf8.encode('$email:$password');
    final base64Encoded = base64UrlEncode(encodedData).replaceAll('=', '');

    final headers = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic $base64Encoded',
    };

    final data = <String, dynamic>{
      'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      'assertion': jwtVc,
    };

    final response = await client.post(
      '$url/configuration',
      headers: headers,
      data: data,
    );

    /// parse
    final header = jwtDecode.parseJwtHeader(response as String);
    final issuerKid = header['kid'].toString();
    final issuerDid = issuerKid.split('#')[0];

    /// verify
    final VerificationType isVerified = await verifyEncodedData(
      issuerDid,
      issuerKid,
      response,
    );

    final profileSettingJson = jwtDecode.parseJwt(response);

    await profileCubit.secureStorageProvider.set(
      SecureStorageKeys.enterpriseProfileSetting,
      jsonEncode(profileSettingJson),
    );

    final profileSetting = ProfileSetting.fromJson(profileSettingJson);

    ///save to profileCubit
    await profileCubit.setProfileSetting(
      profileSetting: profileSetting,
      profileType: ProfileType.enterprise,
    );

    // if (isVerified == VerificationType.verified) {
    //   emit(
    //     state.copyWith(
    //       status: AppStatus.idle,
    //       message: const StateMessage.info(
    //         showDialog: true,
    //         stringMessage: 'Verfied',
    //       ),
    //     ),
    //   );
    // } else {
    //   emit(
    //     state.copyWith(
    //       status: AppStatus.idle,
    //       message: const StateMessage.info(
    //         showDialog: true,
    //         stringMessage: 'Not Verfied',
    //       ),
    //     ),
    //   );
    // }

    emit(
      state.copyWith(
        status: AppStatus.success,
        message: null,
      ),
    );
  }

  Future<String> getNonce(String url) async {
    final dynamic getRepsponse = await client.get('$url/nonce');
    final nonce = getRepsponse['nonce'].toString();
    return nonce;
  }

  Future<Map<String, dynamic>> getDataForRequest(String nonce) async {
    /// get private key
    final p256KeyForWallet =
        await getWalletP256Key(profileCubit.secureStorageProvider);
    final privateKey = jsonDecode(p256KeyForWallet) as Map<String, dynamic>;

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

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
    final jwtToken = profileCubit.oidc4vc.generateToken(
      payload: payload,
      tokenParameters: tokenParameters,
    );

    final data = {
      'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      'assertion': jwtToken,
    };
    return data;
  }

  Future<String> getWalletAttestationData(String url) async {
    /// GET nonce
    final nonce = await getNonce(url);

    /// get data to send to attestation request
    final Map<String, dynamic> data = await getDataForRequest(nonce);

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
    final header = jwtDecode.parseJwtHeader(jwtVc!);
    final issuerKid = header['kid'].toString();
    final issuerDid = issuerKid.split('#')[0];

    /// verify
    final VerificationType isVerified = await verifyEncodedData(
      issuerDid,
      issuerKid,
      jwtVc,
    );

    await profileCubit.secureStorageProvider.set(
      SecureStorageKeys.walletAttestationData,
      jwtVc,
    );

    return jwtVc;
  }

  Future<void> updateTheConfiguration() async {
    try {
      emit(state.loading());

      final savedEmail = await profileCubit.secureStorageProvider.get(
        SecureStorageKeys.enterpriseEmail,
      );
      final savedPassword = await profileCubit.secureStorageProvider.get(
        SecureStorageKeys.enterprisePassword,
      );

      final provider = await profileCubit.secureStorageProvider.get(
        SecureStorageKeys.enterpriseWalletProvider,
      );

      final walletAttestationData =
          await profileCubit.secureStorageProvider.get(
        SecureStorageKeys.walletAttestationData,
      );

      if (savedEmail == null ||
          savedPassword == null ||
          provider == null ||
          walletAttestationData == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The wallet is not configured yet.',
          },
        );
      }

      final encodedData = utf8.encode('$savedEmail:$savedPassword');
      final base64Encoded = base64UrlEncode(encodedData).replaceAll('=', '');

      final headers = <String, dynamic>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic $base64Encoded',
      };

      final data = <String, dynamic>{
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': walletAttestationData,
      };

      final response = await client.post(
        '$provider/update',
        headers: headers,
        data: data,
      );

      /// parse
      final header = jwtDecode.parseJwtHeader(response as String);
      final issuerKid = header['kid'].toString();
      final issuerDid = issuerKid.split('#')[0];

      /// verify
      final VerificationType isVerified = await verifyEncodedData(
        issuerDid,
        issuerKid,
        response,
      );

      final profileSettingJson = jwtDecode.parseJwt(response);

      await profileCubit.secureStorageProvider.set(
        SecureStorageKeys.enterpriseProfileSetting,
        jsonEncode(profileSettingJson),
      );

      final profileSetting = ProfileSetting.fromJson(profileSettingJson);

      ///save to profileCubit
      await profileCubit.setProfileSetting(
        profileSetting: profileSetting,
        profileType: ProfileType.enterprise,
      );
      // if (isVerified == VerificationType.verified) {
      //   emit(
      //     state.copyWith(
      //       status: AppStatus.idle,
      //       message: const StateMessage.info(
      //         showDialog: true,
      //         stringMessage: 'Verfied',
      //       ),
      //     ),
      //   );
      // } else {
      //   emit(
      //     state.copyWith(
      //       status: AppStatus.idle,
      //       message: const StateMessage.info(
      //         showDialog: true,
      //         stringMessage: 'Not Verfied',
      //       ),
      //     ),
      //   );
      // }

      emit(
        state.copyWith(
          status: AppStatus.success,
          message: StateMessage.success(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_successfullyUpdatedEnterpriseAccount,
            ),
          ),
        ),
      );
    } catch (e) {
      emitError(e);
    }
  }

  void emitError(dynamic e) {
    final messageHandler = getMessageHandler(e);

    emit(
      state.error(
        message: StateMessage.error(
          messageHandler: messageHandler,
          showDialog: true,
        ),
      ),
    );
  }
}
