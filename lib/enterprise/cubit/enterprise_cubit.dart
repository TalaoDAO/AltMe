import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';

part 'enterprise_cubit.g.dart';

part 'enterprise_state.dart';

class EnterpriseCubit extends Cubit<EnterpriseState> {
  EnterpriseCubit({
    required this.client,
    required this.profileCubit,
    required this.credentialsCubit,
    required this.altmeChatSupportCubit,
    required this.matrixNotificationCubit,
  }) : super(const EnterpriseState());

  final DioClient client;
  final ProfileCubit profileCubit;
  final CredentialsCubit credentialsCubit;
  final AltmeChatSupportCubit altmeChatSupportCubit;
  final MatrixNotificationCubit matrixNotificationCubit;

  Future<void> requestTheConfiguration({
    required Uri uri,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
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

    final profileSettingJson =
        jsonEncode(profileCubit.jwtDecode.parseJwt(response as String));

    final savedEmail = await profileCubit.secureStorageProvider.get(
      SecureStorageKeys.enterpriseEmail,
    );

    // we emit new state, waiting for user approval

    if (savedEmail == null) {
      // new configuration

      // throw ResponseMessage(
      //   message: ResponseString.RESPONSE_STRING_thisWalleIsAlreadyConfigured,
      // );
      emit(
        state.copyWith(
          status: AppStatus.addEnterpriseAccount,
          profileSettingJson: profileSettingJson,
        ),
      );
    } else {
      if (email == savedEmail) {
        // update old configuraion
        emit(
          state.copyWith(
            status: AppStatus.updateEnterpriseAccount,
            profileSettingJson: profileSettingJson,
          ),
        );
      } else {
        // new configuration
        emit(
          state.copyWith(
            status: AppStatus.replaceEnterpriseAccount,
            profileSettingJson: profileSettingJson,
          ),
        );
      }
    }
  }

  Future<void> applyConfiguration({
    required QRCodeScanCubit qrCodeScanCubit,
    required ManageNetworkCubit manageNetworkCubit,
    required AppStatus status,
  }) async {
    assert(state.profileSettingJson != null, 'Profile setting is missing.');
    emit(state.loading());

    final setting = state.profileSettingJson;
    if (setting != null) {
      await profileCubit.secureStorageProvider.set(
        SecureStorageKeys.enterpriseProfileSetting,
        setting,
      );

      final profileSetting =
          ProfileSetting.fromJson(jsonDecode(setting) as Map<String, dynamic>);

      ///save to profileCubit
      await profileCubit.setProfileSetting(
        profileSetting: profileSetting,
        profileType: ProfileType.enterprise,
      );
      final helpCenterOptions = profileSetting.helpCenterOptions;

      if (helpCenterOptions.customChatSupport &&
          helpCenterOptions.customChatSupportName != null) {
        await altmeChatSupportCubit.init();
      }

      if (helpCenterOptions.customNotification != null &&
          helpCenterOptions.customNotification! &&
          helpCenterOptions.customNotificationRoom != null) {
        await matrixNotificationCubit.init();
      }

      // chat is not initiatied at start

      /// uprade wallet to enterprise
      await profileCubit.setWalletType(
        walletType: WalletType.enterprise,
      );

      final blockchainOptions = profileSetting.blockchainOptions;
      if (blockchainOptions != null) {
        await setUpBlockChainOptions(
          blockchainOptions: blockchainOptions,
          manageNetworkCubit: manageNetworkCubit,
        );
      }

      // if enterprise and walletAttestation data is available and added
      await credentialsCubit.addWalletCredential(
        blockchainType:
            credentialsCubit.walletCubit.state.currentAccount?.blockchainType,
        qrCodeScanCubit: qrCodeScanCubit,
        uri: Uri.parse(Parameters.walletIssuer),
      );

      emit(
        state.copyWith(
          status: status == AppStatus.addEnterpriseAccount
              ? AppStatus.successAdd
              : AppStatus.successUpdate,
          message: StateMessage.success(
            messageHandler: ResponseMessage(
              message: status == AppStatus.addEnterpriseAccount
                  ? ResponseString
                      .RESPONSE_STRING_successfullyAddedEnterpriseAccount
                  : ResponseString
                      .RESPONSE_STRING_successfullyUpdatedEnterpriseAccount,
            ),
          ),
        ),
      );
    }
  }

  Future<String> getNonce(String url) async {
    final dynamic getRepsponse = await client.get('$url/nonce');
    final nonce = getRepsponse['nonce'].toString();
    return nonce;
  }

  Future<Map<String, dynamic>> getDataForRequest(String nonce) async {
    /// get private key
    final p256KeyForWallet =
        await getWalletAttestationP256Key(profileCubit.secureStorageProvider);
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
    final header = profileCubit.jwtDecode.parseJwtHeader(jwtVc);
    final issuerKid = header['kid'].toString();
    final did = issuerKid.split('#')[0];

    /// verify
    final VerificationType isVerified = await verifyEncodedData(
      issuer: did,
      jwtDecode: profileCubit.jwtDecode,
      jwt: jwtVc,
      useOAuthAuthorizationServerLink:
          useOauthServerAuthEndPoint(profileCubit.state.model),
    );

    if (isVerified != VerificationType.verified) {
      throw ResponseMessage(
        message: ResponseString.RESPONSE_STRING_invalidStatus,
      );
    }

    final payload = profileCubit.jwtDecode.parseJwt(jwtVc);
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

          final payload = profileCubit.jwtDecode.parseJwt(response.toString());

          /// verify the signature of the VC with the kid of the JWT
          final VerificationType isVerified = await verifyEncodedData(
            issuer: payload['iss'].toString(),
            jwtDecode: profileCubit.jwtDecode,
            jwt: response.toString(),
            fromStatusList: true,
            useOAuthAuthorizationServerLink:
                useOauthServerAuthEndPoint(profileCubit.state.model),
          );

          if (isVerified != VerificationType.verified) {
            throw ResponseMessage(
              message:
                  ResponseString.RESPONSE_STRING_statusListInvalidSignature,
            );
          }

          final newStatusList = payload['status_list'];
          if (newStatusList != null && newStatusList is Map<String, dynamic>) {
            final lst = newStatusList['lst'].toString();

            final bytes = profileCubit.oidc4vc.getByte(idx);

            // '$idx = $bytes X 8 + $posOfBit'
            final decompressedBytes =
                profileCubit.oidc4vc.decodeAndZlibDecompress(lst);
            final byteToCheck = decompressedBytes[bytes];

            final posOfBit = profileCubit.oidc4vc.getPositionOfZlibBit(idx);
            final bit = profileCubit.oidc4vc
                .getBit(byte: byteToCheck, bitPosition: posOfBit);

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

    await profileCubit.secureStorageProvider
        .set(SecureStorageKeys.walletAttestationData, jwtVc);

    return jwtVc;
  }

  Future<void> getWalletAttestationBitStatus() async {
    try {
      final walletAttestationData =
          await profileCubit.secureStorageProvider.get(
        SecureStorageKeys.walletAttestationData,
      );

      final jwtVc = walletAttestationData.toString();

      final payload = profileCubit.jwtDecode.parseJwt(jwtVc);
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

            final payload =
                profileCubit.jwtDecode.parseJwt(response.toString());

            final newStatusList = payload['status_list'];
            if (newStatusList != null &&
                newStatusList is Map<String, dynamic>) {
              final lst = newStatusList['lst'].toString();

              final bytes = profileCubit.oidc4vc.getByte(idx);

              // '$idx = $bytes X 8 + $posOfBit'
              final decompressedBytes =
                  profileCubit.oidc4vc.decodeAndZlibDecompress(lst);
              final byteToCheck = decompressedBytes[bytes];

              final posOfBit = profileCubit.oidc4vc.getPositionOfZlibBit(idx);
              final bit = profileCubit.oidc4vc
                  .getBit(byte: byteToCheck, bitPosition: posOfBit);

              if (bit == 0) {
                // active
              } else {
                // revoked
                emit(state.copyWith(status: AppStatus.revoked));
              }
            }
          }
        }
      }
    } catch (e) {
      emitError(e);
    }
  }

  Future<void> updateTheConfiguration(
    ManageNetworkCubit manageNetworkCubit,
  ) async {
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

      final profileSettingJson =
          profileCubit.jwtDecode.parseJwt(response as String);

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

      final helpCenterOptions = profileSetting.helpCenterOptions;

      if (helpCenterOptions.customNotification != null &&
          helpCenterOptions.customNotification! &&
          helpCenterOptions.customNotificationRoom != null) {
        final roomName = helpCenterOptions.customNotificationRoom;

        final savedRoomName =
            await matrixNotificationCubit.getRoomIdFromStorage();

        if (roomName != savedRoomName) {
          await matrixNotificationCubit.clearRoomIdFromStorage();
        }

        await matrixNotificationCubit.init();
      }

      final blockchainOptions = profileSetting.blockchainOptions;
      if (blockchainOptions != null) {
        await setUpBlockChainOptions(
          blockchainOptions: blockchainOptions,
          manageNetworkCubit: manageNetworkCubit,
        );
      }

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

  Future<void> setUpBlockChainOptions({
    required ManageNetworkCubit manageNetworkCubit,
    required BlockchainOptions blockchainOptions,
  }) async {
    final testnet = blockchainOptions.testnet;
    if (testnet != null) {
      final blockchainType =
          manageNetworkCubit.walletCubit.state.currentAccount!.blockchainType;
      final currentNetworkList = blockchainType.networks;

      var network = currentNetworkList[0];
      if (testnet) network = currentNetworkList[1];

      await manageNetworkCubit.setNetwork(network);
      await manageNetworkCubit.resetOtherNetworks(network);
    }

    final cryptoAccountDataList =
        credentialsCubit.walletCubit.state.cryptoAccount.data;

    BlockchainType? blockchainType;

    if (blockchainOptions.bnbSupport) {
      blockchainType = BlockchainType.binance;
    } else if (blockchainOptions.ethereumSupport) {
      blockchainType = BlockchainType.ethereum;
    } else if (blockchainOptions.fantomSupport) {
      blockchainType = BlockchainType.fantom;
    } else if (blockchainOptions.polygonSupport) {
      blockchainType = BlockchainType.polygon;
    } else if (blockchainOptions.etherlinkSupport != null &&
        blockchainOptions.etherlinkSupport!) {
      blockchainType = BlockchainType.etherlink;
    } else if (blockchainOptions.tezosSupport) {
      blockchainType = BlockchainType.tezos;
    }

    if (blockchainType != null) {
      final index = cryptoAccountDataList
          .indexWhereOrNull((a) => a.blockchainType == blockchainType);
      if (index != null) {
        await credentialsCubit.walletCubit.setCurrentWalletAccount(index);
      }
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

  Future<void> getWalletProviderAccount(
    QRCodeScanCubit qrCodeScanCubit,
  ) async {
    late final dynamic configurationResponse;
    // check if wallet is Altme or Talao
    if (Parameters.appName == 'Altme') {
      // get configuration file for this device
      configurationResponse = await client.get(Urls.walletConfigurationAltme);
    }
    if (Parameters.appName == 'Talao') {
      // get configuration file for this device
      configurationResponse = await client.get(Urls.walletConfigurationTalao);
    }
    if (configurationResponse != null &&
        configurationResponse is Map<String, dynamic>) {
      if (configurationResponse['login'] != null &&
          configurationResponse['password'] != null &&
          configurationResponse['wallet-provider'] != null) {
        final uri = Uri.https('example.com', '/path', configurationResponse);
        await requestTheConfiguration(
          uri: uri,
          qrCodeScanCubit: qrCodeScanCubit,
        );
      }
    }
  }
}
