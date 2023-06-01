import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hex/hex.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polygonid/polygonid.dart';

import 'package:secure_storage/secure_storage.dart';

part 'polygon_id_cubit.g.dart';
part 'polygon_id_state.dart';

class PolygonIdCubit extends Cubit<PolygonIdState> {
  PolygonIdCubit({
    required this.polygonId,
    required this.secureStorageProvider,
    required this.credentialsCubit,
    required this.client,
    required this.profileCubit,
  }) : super(const PolygonIdState());

  final SecureStorageProvider secureStorageProvider;
  final PolygonId polygonId;
  final CredentialsCubit credentialsCubit;
  final DioClient client;
  final ProfileCubit profileCubit;

  final log = getLogger('PolygonIdCubit');

  StreamSubscription<DownloadInfo>? _subscription;

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  Future<void> initialise() async {
    try {
      if (PolygonId().isInitialized) {
        emit(
          state.copyWith(
            status: AppStatus.idle,
            isInitialised: true,
          ),
        );
        return;
      }

      /// PolygonId SDK initialization
      await dotenv.load();

      final polygonIdNetwork =
          await secureStorageProvider.get(SecureStorageKeys.polygonIdNetwork);

      String network = Parameters.POLYGON_MAIN_NETWORK;

      if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet.toString()) {
        network = Parameters.POLYGON_MAIN_NETWORK;
        await PolygonId().init(
          network: network,
          web3Url: Parameters.INFURA_URL,
          web3RdpUrl: Parameters.INFURA_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_API_KEY'),
          idStateContract: Parameters.ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.PUSH_URL,
        );
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
        await PolygonId().init(
          network: network,
          web3Url: Parameters.INFURA_MUMBAI_URL,
          web3RdpUrl: Parameters.INFURA_MUMBAI_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_MUMBAI_API_KEY'),
          idStateContract: Parameters.MUMBAI_ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.MUMBAI_PUSH_URL,
        );
      }

      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      //addIdentity
      await polygonId.addIdentity(mnemonic: mnemonic!, network: network);
      emit(
        state.copyWith(
          status: AppStatus.init,
          isInitialised: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.error,
          isInitialised: false,
        ),
      );
      throw Exception('INIT_ISSUE - $e');
    }
  }

  Future<void> setEnv(PolygonIdNetwork polygonIdNetwork) async {
    try {
      /// PolygonId SDK update
      await dotenv.load();

      if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet) {
        await PolygonId().setEnv(
          network: Parameters.POLYGON_MAIN_NETWORK,
          web3Url: Parameters.INFURA_URL,
          web3RdpUrl: Parameters.INFURA_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_API_KEY'),
          idStateContract: Parameters.ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.PUSH_URL,
        );
      } else {
        await PolygonId().setEnv(
          network: Parameters.POLYGON_TEST_NETWORK,
          web3Url: Parameters.INFURA_MUMBAI_URL,
          web3RdpUrl: Parameters.INFURA_MUMBAI_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_MUMBAI_API_KEY'),
          idStateContract: Parameters.MUMBAI_ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.MUMBAI_PUSH_URL,
        );
      }
      //final data = await PolygonId().getEnv();
      //print(data.toString());
      emit(state.copyWith(status: AppStatus.idle));
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.error,
        ),
      );
      throw Exception('UPDATE_ISSUE - $e');
    }
  }

  Future<void> polygonIdFunction(String scannedResponse) async {
    try {
      await initialise();

      emit(
        state.copyWith(
          status: AppStatus.loading,
          scannedResponse: scannedResponse,
        ),
      );

      log.i('download circuit');
      //download circuit
      final isCircuitAlreadyDownloaded = await polygonId.isCircuitsDownloaded();
      if (isCircuitAlreadyDownloaded) {
        log.i('circuit already downloaded');
        await polygonActions();
      } else {
        // show loading with authentication message

        emit(
          state.copyWith(
            status: AppStatus.loading,
            loadingText: ResponseMessage(
              ResponseString.RESPONSE_STRING_downloadingCircuitLoadingMessage,
            ),
          ),
        );

        final Stream<DownloadInfo> stream =
            polygonId.initCircuitsDownloadAndGetInfoStream;
        _subscription = stream.listen((DownloadInfo downloadInfo) async {
          if (downloadInfo is DownloadInfoOnDone) {
            unawaited(_subscription?.cancel());
            log.i('download circuit complete');
            await polygonActions();
          } else if (downloadInfo is DownloadInfoOnProgress) {
            // loading value update
            final double loadedValue =
                downloadInfo.downloaded / downloadInfo.contentLength;
            final roundedValue = double.parse(loadedValue.toStringAsFixed(1));
            log.i(roundedValue);
          } else {
            throw ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            );
          }
        });
      }
    } catch (e) {
      log.e(e);
      if (e is MessageHandler) {
        emit(state.error(message: StateMessage.error(messageHandler: e)));
      } else {
        emit(
          state.copyWith(
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<Iden3MessageEntity> getIden3Message({required String message}) async {
    final Iden3MessageEntity iden3MessageEntity =
        await polygonId.getIden3Message(message: message);
    return iden3MessageEntity;
  }

  Future<void> polygonActions() async {
    final Iden3MessageEntity iden3MessageEntity =
        await getIden3Message(message: state.scannedResponse!);

    if (iden3MessageEntity.messageType == Iden3MessageType.auth) {
      final body = iden3MessageEntity.body as AuthBodyRequest;

      if (body.scope!.isEmpty) {
        log.i('issuer');
        emit(
          state.copyWith(
            status: AppStatus.loading,
            polygonAction: PolygonIdAction.issuer,
          ),
        );
      } else {
        log.i('verifier');
        emit(
          state.copyWith(
            status: AppStatus.loading,
            polygonAction: PolygonIdAction.verifier,
          ),
        );
      }
    } else if (iden3MessageEntity.messageType == Iden3MessageType.offer) {
      log.i('get claims');
      emit(
        state.copyWith(
          status: AppStatus.loading,
          polygonAction: PolygonIdAction.offer,
        ),
      );
    } else if (iden3MessageEntity.messageType ==
        Iden3MessageType.contractFunctionCall) {
      log.i('contractFunctionCall');
      emit(
        state.copyWith(
          status: AppStatus.loading,
          polygonAction: PolygonIdAction.contractFunctionCall,
        ),
      );
    } else {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
      );
    }
  }

  Future<void> authenticateOrGenerateProof({
    required Iden3MessageEntity iden3MessageEntity,
    bool isGenerateProof = true,
  }) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      final polygonIdNetwork =
          await secureStorageProvider.get(SecureStorageKeys.polygonIdNetwork);

      String network = Parameters.POLYGON_MAIN_NETWORK;

      if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet.toString()) {
        network = Parameters.POLYGON_MAIN_NETWORK;
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
      }

      log.i('polygonId authentication');
      final isAuthenticated = await polygonId.authenticate(
        iden3MessageEntity: iden3MessageEntity,
        mnemonic: mnemonic!,
        network: network,
      );

      if (isAuthenticated) {
        emit(
          state.copyWith(
            status: isGenerateProof ? AppStatus.goBack : AppStatus.idle,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                isGenerateProof
                    ? ResponseString.RESPONSE_STRING_successfullyGeneratingProof
                    : ResponseString.RESPONSE_STRING_succesfullyAuthenticated,
              ),
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          isGenerateProof
              ? ResponseString.RESPONSE_STRING_errorGeneratingProof
              : ResponseString.RESPONSE_STRING_authenticationFailed,
        );
      }
    } catch (e) {
      log.e(e);
      if (e is MessageHandler) {
        emit(state.error(message: StateMessage.error(messageHandler: e)));
      } else {
        emit(
          state.copyWith(
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  /// Fetch a list of [ClaimEntity] from issuer using iden3comm message
  /// and stores them in Polygon Id Sdk.
  ///
  /// The iden3MessageEntity is the iden3comm message entity
  ///
  /// The did is the unique id of the identity
  ///
  /// The profileNonce is the nonce of the profile used from identity
  /// to obtain the did identifier
  ///
  /// The privateKe] is the key used to access all the sensitive info from the
  /// identity and also to realize operations like generating proofs
  Future<List<ClaimEntity>> getClaims({
    required Iden3MessageEntity iden3MessageEntity,
  }) async {
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);

    final polygonIdNetwork =
        await secureStorageProvider.get(SecureStorageKeys.polygonIdNetwork);

    String network = Parameters.POLYGON_MAIN_NETWORK;

    if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet.toString()) {
      network = Parameters.POLYGON_MAIN_NETWORK;
    } else {
      network = Parameters.POLYGON_TEST_NETWORK;
    }

    final List<ClaimEntity> claims = await polygonId.getClaims(
      iden3MessageEntity: iden3MessageEntity,
      mnemonic: mnemonic!,
      network: network,
    );
    return claims;
  }

  Future<void> addPolygonIdCredentials({
    required List<ClaimEntity> claims,
  }) async {
    try {
      log.i('add Claims');
      emit(state.copyWith(status: AppStatus.loading));
      for (final claim in claims) {
        await addToList(claim);
      }
      emit(state.copyWith(status: AppStatus.goBack));
    } catch (e) {
      log.e(e);
      if (e is MessageHandler) {
        emit(state.error(message: StateMessage.error(messageHandler: e)));
      } else {
        emit(
          state.copyWith(
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> addToList(ClaimEntity claimEntity) async {
    final jsonCredential = claimEntity.info;
    final credentialPreview = Credential.fromJson(jsonCredential);

    CredentialManifest? credentialManifest;
    try {
      // Try to get Credential manifest for kycAgeCredential
      // and kycCountryOfResidence
      if (claimEntity.type == CredentialSubjectType.kycAgeCredential.name) {
        final response = await client.get(Urls.kycAgeCredentialUrl);
        credentialManifest =
            CredentialManifest.fromJson(response as Map<String, dynamic>);
      } else if (claimEntity.type ==
          CredentialSubjectType.kycCountryOfResidence.name) {
        final response = await client.get(Urls.kycCountryOfResidenceUrl);
        credentialManifest =
            CredentialManifest.fromJson(response as Map<String, dynamic>);
      }
    } catch (e) {
      log.e('can not get the credntials manifest for polygon error: $e');
    }

    final credentialModel = CredentialModel(
      id: claimEntity.id,
      image: 'image',
      data: jsonCredential,
      display: Display.emptyDisplay()..toJson(),
      shareLink: '',
      credentialPreview: credentialPreview,
      credentialManifest: credentialManifest,
      expirationDate: claimEntity.expiration,
      activities: [Activity(acquisitionAt: DateTime.now())],
    );
    // insert the credential in the wallet
    await credentialsCubit.insertCredential(credential: credentialModel);
  }

  /// getSchemas
  Future<List<Map<String, dynamic>>> getSchemas({
    required Iden3MessageEntity message,
  }) async {
    return polygonId.getSchemas(message: message);
  }

  /// getFilteredClaims
  Future<List<ClaimEntity?>> getClaimsFromIden3Message({
    required Iden3MessageEntity iden3MessageEntity,
    required String mnemonic,
  }) async {
    final polygonIdNetwork =
        await secureStorageProvider.get(SecureStorageKeys.polygonIdNetwork);

    String network = Parameters.POLYGON_MAIN_NETWORK;

    if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet.toString()) {
      network = Parameters.POLYGON_MAIN_NETWORK;
    } else {
      network = Parameters.POLYGON_TEST_NETWORK;
    }
    return polygonId.getClaimsFromIden3Message(
      iden3MessageEntity: iden3MessageEntity,
      mnemonic: mnemonic,
      network: network,
    );
  }

  Future<void> generateProofByContractFunctionCall({
    required String walletAddress,
  }) async {
    return;
  }
}
