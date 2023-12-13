import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/models/profile_setting.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'login_cubit.g.dart';

part 'login_state.dart';

class EnterpriseLoginCubit extends Cubit<EnterpriseLoginState> {
  EnterpriseLoginCubit({
    required this.client,
    required this.secureStorageProvider,
    required this.jwtDecode,
    required this.oidc4vc,
    required this.profileCubit,
  }) : super(const EnterpriseLoginState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;
  final JWTDecode jwtDecode;
  final OIDC4VC oidc4vc;
  final ProfileCubit profileCubit;

  void updateEmailFormat(String email) {
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,}$';

    final regExpEmail = RegExp(emailPattern);

    final isValid = regExpEmail.hasMatch(email);
    emit(
      state.copyWith(
        isEmailFormatCorrect: isValid,
        message: null,
      ),
    );
  }

  void updatePasswordFormat(String password) {
    emit(
      state.copyWith(
        isPasswordFormatCorrect: password.trim().length >= 3,
        message: null,
      ),
    );
  }

  void obscurePassword() {
    emit(
      state.copyWith(
        obscurePassword: !state.obscurePassword,
        message: null,
      ),
    );
  }

  String? jwtVc;

  Future<void> requestTheConfiguration({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.loading());
      final bool isDataEntered =
          state.isEmailFormatCorrect && state.isPasswordFormatCorrect;

      if (jwtVc == null) {
        /// GET nonce
        final nonce = await getNonce();

        /// get data to send to attestation request
        final Map<String, dynamic> data = await getDataForRequest(nonce);

        /// get vc and store it in the wallet
        await getJWTVc(data);

        if (!isDataEntered) {
          return emit(state.copyWith(status: AppStatus.idle, message: null));
        }
      }

      /// request the configuration and verify
      await requestTheConfigurationAndVerify(email: email, password: password);
    } catch (e) {
      emitError(e);
    }
  }

  Future<void> requestTheConfigurationAndVerify({
    required String email,
    required String password,
  }) async {
    /// request the configuration
    //final encodedData = utf8.encode('thierry@altme.io:talao');
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
      '${Urls.walletProvider}/configuration',
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

    //final profileSettingJson = jwtDecode.parseJwt(response);

    final profileSettingJson = {
      "version": "1.9",
      "generalOptions": {
        "walletType": "altme",
        "companyName": "Altme",
        "companyWebsite": "https://altme.io",
        "companyLogo": "https://talao.co/static/img/icon.png",
        "tagLine": "hhhhhhhhh",
        "profileName": "Wallet Profile Demo",
        "profileVersion": "1.0",
        "published": "2023-12-03",
        "profileId": "urn:uuid:lkjhj",
        "customerPlan": "free"
      },
      "settingsMenu": {
        "displayProfile": true,
        "displayDeveloperMode": false,
        "displayHelpCenter": true
      },
      "walletSecurityOptions": {
        "displaySecurityAdvancedSettings": false,
        "verifySecurityIssuerWebsiteIdentity": false,
        "confirmSecurityVerifierAccess": false,
        "secureSecurityAuthenticationWithPinCode": true
      },
      "blockchainOptions": {
        "tezosSupport": true,
        "ethereumSupport": true,
        "hederaSupport": true,
        "bnbSupport": true,
        "fantomSupport": true,
        "polygonSupport": true,
        "tzproRpcNode": false,
        "tzproApiKey": null,
        "infuraRpcNode": false,
        "infuraApiKey": null
      },
      "selfSovereignIdentityOptions": {
        "displayManageDecentralizedId": true,
        "displaySsiAdvancedSettings": true,
        "displayVerifiableDataRegistry": true,
        "oidv4vcProfile": "ebsi",
        "customOidc4vcProfile": {
          "securityLevel": "low",
          "credentialManifestSupport": true,
          "userPinDigits": "4",
          "defaultDid": "did:key:ebsi",
          "subjectSyntaxeType": "did",
          "cryptoHolderBinding": true,
          "scope": false,
          "clientAuthentication": "none",
          "client_id": null,
          "client_secret": null,
          "oidc4vciDraft": "11",
          "oidc4vpDraft": "18",
          "siopv2Draft": "12"
        }
      },
      "helpCenterOptions": {
        "displayChatSupport": true,
        "customChatSupport": false,
        "customChatSupportName": null,
        "displayEmailSupport": true,
        "customEmailSupport": false,
        "customEmail": null
      }
    };

    await secureStorageProvider.set(
      SecureStorageKeys.enterpriseConfiguration,
      jsonEncode(profileSettingJson),
    );

    final profileSetting = ProfileSetting.fromJson(profileSettingJson);

    ///save to profileCubit
    await profileCubit.setProfileSetting(profileSetting);
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

  Future<String> getNonce() async {
    final dynamic getRepsponse =
        await client.get('${Urls.walletProvider}/nonce');
    final nonce = getRepsponse['nonce'].toString();
    return nonce;
  }

  Future<Map<String, dynamic>> getDataForRequest(String nonce) async {
    /// get private key
    final p256KeyForWallet = await getWalletP256Key(secureStorageProvider);
    final privateKey = jsonDecode(p256KeyForWallet) as Map<String, dynamic>;

    final tokenParameters = TokenParameters(
      privateKey: privateKey,
      did: '',
      kid: null,
      mediaType: MediaType.walletAttestation,
      useJWKThumbPrint: false,
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
    final jwtToken = oidc4vc.generateToken(
      payload: payload,
      tokenParameters: tokenParameters,
    );

    final data = {
      'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      'assertion': jwtToken,
    };
    return data;
  }

  Future<String> getJWTVc(Map<String, dynamic> data) async {
    /// get vc
    final response = await client.post(
      '${Urls.walletProvider}/token',
      headers: <String, dynamic>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      data: data,
    );

    jwtVc = response.toString();

    /// parse
    final header = jwtDecode.parseJwtHeader(jwtVc!);
    final issuerKid = header['kid'].toString();
    final issuerDid = issuerKid.split('#')[0];

    /// verify
    final VerificationType isVerified = await verifyEncodedData(
      issuerDid,
      issuerKid,
      jwtVc!,
    );

    await secureStorageProvider.set(
      SecureStorageKeys.walletAttestationData,
      jwtVc!,
    );

    return jwtVc!;
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
