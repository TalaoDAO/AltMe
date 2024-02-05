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

part 'update_cubit.g.dart';

part 'update_state.dart';

class EnterpriseUpdateCubit extends Cubit<EnterpriseUpdateState> {
  EnterpriseUpdateCubit({
    required this.client,
    required this.secureStorageProvider,
    required this.jwtDecode,
    required this.profileCubit,
  }) : super(const EnterpriseUpdateState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;
  final JWTDecode jwtDecode;

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

  void obscurePassword() {
    emit(
      state.copyWith(
        obscurePassword: !state.obscurePassword,
        message: null,
      ),
    );
  }

  Future<void> updateTheConfiguration({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.loading());
      final encodedData = utf8.encode('$email:$password');
      final base64Encoded = base64UrlEncode(encodedData).replaceAll('=', '');

      final walletAttestationData = await secureStorageProvider.get(
        SecureStorageKeys.walletAttestationData,
      );

      final headers = <String, dynamic>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic $base64Encoded',
      };

      final data = <String, dynamic>{
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': walletAttestationData,
      };

      final walletProviderTypeString = await secureStorageProvider.get(
        SecureStorageKeys.walletProviderType,
      );

      final walletProviderType = walletProviderTypeString != null
          ? WalletProviderType.values.firstWhereOrNull(
              (type) => type.toString() == walletProviderTypeString,
            )
          : WalletProviderType.Talao;

      if (walletProviderType == null) throw Exception();

      final response = await client.post(
        '${walletProviderType.url}/update',
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
