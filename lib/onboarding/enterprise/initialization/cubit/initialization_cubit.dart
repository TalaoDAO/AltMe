import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'initialization_cubit.g.dart';

part 'initialization_state.dart';

class EnterpriseInitializationCubit
    extends Cubit<EnterpriseInitializationState> {
  EnterpriseInitializationCubit({
    required this.client,
    required this.secureStorageProvider,
    required this.jwtDecode,
    required this.oidc4vc,
    required this.profileCubit,
  }) : super(const EnterpriseInitializationState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;
  final JWTDecode jwtDecode;
  final OIDC4VC oidc4vc;
  final ProfileCubit profileCubit;

  void updateEmailFormat(String email) {
    final regExpEmail = RegExp(AltMeStrings.emailPattern);

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

  Future<void> setWalletProviderType(
    WalletProviderType walletProviderType,
  ) async {
    emit(state.loading());
    await secureStorageProvider.set(
      SecureStorageKeys.walletProviderType,
      walletProviderType.toString(),
    );
    emit(
      state.copyWith(
        walletProviderType: walletProviderType,
        message: null,
        status: AppStatus.idle,
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
      // TODO(bibash): need to remove this hardcode later
      emit(
        state.error(
          message: const StateMessage.error(
            stringMessage:
                'User not registered or email/password are incorrect',
            showDialog: true,
          ),
        ),
      );
      jwtVc = null;
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
      '${state.walletProviderType.url}/configuration',
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

    await secureStorageProvider.set(
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

  Future<String> getNonce() async {
    final dynamic getRepsponse =
        await client.get('${state.walletProviderType.url}/nonce');
    final nonce = getRepsponse['nonce'].toString();
    return nonce;
  }

  Future<Map<String, dynamic>> getDataForRequest(String nonce) async {
    /// get private key
    final p256KeyForWallet = await getWalletP256Key(secureStorageProvider);
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
      '${state.walletProviderType.url}/token',
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
