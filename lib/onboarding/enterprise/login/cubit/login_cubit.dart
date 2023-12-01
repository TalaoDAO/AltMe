import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
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
  }) : super(const EnterpriseLoginState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;
  final JWTDecode jwtDecode;
  final OIDC4VC oidc4vc;

  void updateEmailFormat(String email) {
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,}$';

    final regExpEmail = RegExp(emailPattern);

    final isValid = regExpEmail.hasMatch(email);
    emit(state.copyWith(isEmailFormatCorrect: isValid));
  }

  void updatePasswordFormat(String password) {
    emit(state.copyWith(isPasswordFormatCorrect: password.trim().length >= 3));
  }

  void obscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
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
          return emit(state.copyWith(status: AppStatus.idle));
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

    if (isVerified == VerificationType.verified) {
      emit(
        state.copyWith(
          status: AppStatus.idle,
          message: const StateMessage.info(
            showDialog: true,
            stringMessage: 'Verfied',
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AppStatus.idle,
          message: const StateMessage.info(
            showDialog: true,
            stringMessage: 'Not Verfied',
          ),
        ),
      );
    }
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

    return response as String;
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
