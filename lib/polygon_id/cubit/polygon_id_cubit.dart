import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    required this.walletCubit,
  }) : super(const PolygonIdState());

  final SecureStorageProvider secureStorageProvider;
  final PolygonId polygonId;
  final CredentialsCubit credentialsCubit;
  final DioClient client;
  final ProfileCubit profileCubit;
  final WalletCubit walletCubit;

  final log = getLogger('PolygonIdCubit');

  StreamSubscription<DownloadInfo>? _subscription;

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  Future<void> initialise() async {
    try {
      if (polygonId.isInitialized) {
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

      var polygonIdNetwork =
          await secureStorageProvider.get(SecureStorageKeys.polygonIdNetwork);

      final String ipfsApiKey = dotenv.get('IPFS_API_KEY');
      final String ipfsApiKeySecret = dotenv.get('IPFS_API_KEY_SECRET');

      final String ipfsUrl =
          'https://$ipfsApiKey:$ipfsApiKeySecret@ipfs.infura.io:5001';

      String network = Parameters.POLYGON_MAIN_NETWORK;
      PolygonIdNetwork currentNetwork = PolygonIdNetwork.PolygonMainnet;

      // set polygon main network a first
      if (polygonIdNetwork == null) {
        final network = PolygonIdNetwork.PolygonMainnet.toString();
        await secureStorageProvider.set(
          SecureStorageKeys.polygonIdNetwork,
          network,
        );
        polygonIdNetwork = network;
      }

      if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet.toString()) {
        network = Parameters.POLYGON_MAIN_NETWORK;
        currentNetwork = PolygonIdNetwork.PolygonMainnet;
        await polygonId.init(
          network: network,
          web3Url: Parameters.POLYGON_INFURA_URL,
          web3RdpUrl: Parameters.INFURA_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_API_KEY'),
          idStateContract: Parameters.ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.PUSH_URL,
          ipfsUrl: ipfsUrl,
        );
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
        currentNetwork = PolygonIdNetwork.PolygonMumbai;
        await polygonId.init(
          network: network,
          web3Url: Parameters.INFURA_MUMBAI_URL,
          web3RdpUrl: Parameters.INFURA_MUMBAI_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_API_KEY'),
          idStateContract: Parameters.MUMBAI_ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.MUMBAI_PUSH_URL,
          ipfsUrl: ipfsUrl,
        );
      }

      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      //addIdentity
      await polygonId.addIdentity(mnemonic: mnemonic!, network: network);
      log.i('$network - get Identity');
      emit(
        state.copyWith(
          status: AppStatus.init,
          isInitialised: true,
          currentNetwork: currentNetwork,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, isInitialised: false));
      throw ResponseMessage(
        message: ResponseString.RESPONSE_STRING_deviceIncompatibilityMessage,
      );
    }
  }

  Future<void> setEnv(PolygonIdNetwork polygonIdNetwork) async {
    try {
      await initialise();

      /// PolygonId SDK update
      await dotenv.load();

      final String ipfsApiKey = dotenv.get('IPFS_API_KEY');
      final String ipfsApiKeySecret = dotenv.get('IPFS_API_KEY_SECRET');

      final String ipfsUrl =
          'https://$ipfsApiKey:$ipfsApiKeySecret@ipfs.infura.io:5001';

      String network = Parameters.POLYGON_MAIN_NETWORK;
      if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet) {
        network = Parameters.POLYGON_MAIN_NETWORK;
        await polygonId.setEnv(
          network: Parameters.POLYGON_MAIN_NETWORK,
          web3Url: Parameters.POLYGON_INFURA_URL,
          web3RdpUrl: Parameters.INFURA_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_API_KEY'),
          idStateContract: Parameters.ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.PUSH_URL,
          ipfsUrl: ipfsUrl,
        );
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
        await polygonId.setEnv(
          network: Parameters.POLYGON_TEST_NETWORK,
          web3Url: Parameters.INFURA_MUMBAI_URL,
          web3RdpUrl: Parameters.INFURA_MUMBAI_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_API_KEY'),
          idStateContract: Parameters.MUMBAI_ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.MUMBAI_PUSH_URL,
          ipfsUrl: ipfsUrl,
        );
      }

      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      //addIdentity
      await polygonId.addIdentity(mnemonic: mnemonic!, network: network);
      log.i('$network - get Identity');
      emit(
        state.copyWith(
          status: AppStatus.idle,
          currentNetwork: polygonIdNetwork,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));

      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'UPDATE_ISSUE - $e',
        },
      );
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
              message: ResponseString
                  .RESPONSE_STRING_downloadingCircuitLoadingMessage,
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
              message: ResponseString
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
                message: ResponseString
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

    bool checkNetwork = true;

    if (iden3MessageEntity.messageType == Iden3MessageType.authRequest) {
      final body = iden3MessageEntity.body as AuthBodyRequest;

      if (body.scope!.isNotEmpty) {
        log.i('do not consider network for verifier');
        checkNetwork = false;
      }
    }

    if (checkNetwork &&
        !iden3MessageEntity.from.contains(state.currentNetwork.tester)) {
      emit(
        state.copyWith(
          status: AppStatus.error,
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              message:
                  ResponseString.RESPONSE_STRING_pleaseSwitchPolygonNetwork,
            ),
            injectedMessage: state.currentNetwork.oppositeNetwork,
          ),
        ),
      );
      return;
    }

    if (iden3MessageEntity.messageType == Iden3MessageType.authRequest) {
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
    } else if (iden3MessageEntity.messageType ==
        Iden3MessageType.credentialOffer) {
      try {
        final List<ClaimEntity> claims = await getClaims(
          iden3MessageEntity: iden3MessageEntity,
        );

        final List<CredentialManifest> credentialManifests =
            <CredentialManifest>[];

        for (final claimEntity in claims) {
          dynamic response;

          // Try to get Credential manifest for kycAgeCredential
          // and kycCountryOfResidence and proofOfTwitterStatsUrl
          if (claimEntity.type == CredentialSubjectType.kycAgeCredential.name) {
            response = await client.get(Urls.kycAgeCredentialUrl);
          } else if (claimEntity.type ==
              CredentialSubjectType.kycCountryOfResidence.name) {
            response = await client.get(Urls.kycCountryOfResidenceUrl);
          } else if (claimEntity.type ==
              CredentialSubjectType.proofOfTwitterStats.name) {
            response = await client.get(Urls.proofOfTwitterStatsUrl);
          } else if (claimEntity.type ==
              CredentialSubjectType.civicPassCredential.name) {
            response = await client.get(Urls.civicPassCredentialUrl);
          } else {
            response = await client.get(Urls.defaultPolygonIdCardUrl);
          }

          final CredentialManifest credentialManifest =
              CredentialManifest.fromJson(response as Map<String, dynamic>);

          credentialManifests.add(credentialManifest);
        }

        if (claims.length != credentialManifests.length) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_format',
              'error_description':
                  'The claims length and crdential manifest length '
                      "doesn't match.",
            },
          );
        }

        log.i('get claims');
        emit(
          state.copyWith(
            status: AppStatus.loading,
            polygonAction: PolygonIdAction.offer,
            claims: claims,
            credentialManifests: credentialManifests,
          ),
        );
      } catch (e) {
        log.e('can not get the credntials manifest for polygon error: $e');
        throw ResponseMessage(
          message: ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
    } else if (iden3MessageEntity.messageType ==
        Iden3MessageType.proofContractInvokeRequest) {
      log.i('contractFunctionCall');
      emit(
        state.copyWith(
          status: AppStatus.loading,
          polygonAction: PolygonIdAction.contractFunctionCall,
        ),
      );
    } else {
      throw ResponseMessage(
        message:
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

      String network = Parameters.POLYGON_MAIN_NETWORK;

      if (state.currentNetwork == PolygonIdNetwork.PolygonMainnet) {
        network = Parameters.POLYGON_MAIN_NETWORK;
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
      }

      log.i('iden3MessageEntity - $iden3MessageEntity');

      log.i('polygonId authentication - $network');
      final isAuthenticated = await polygonId.authenticate(
        iden3MessageEntity: iden3MessageEntity,
        mnemonic: mnemonic!,
        network: network,
      );
      log.i('isAuthenticated - $isAuthenticated');

      if (isAuthenticated) {
        emit(
          state.copyWith(
            status: isGenerateProof ? AppStatus.goBack : AppStatus.idle,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                message: isGenerateProof
                    ? ResponseString.RESPONSE_STRING_successfullyGeneratingProof
                    : ResponseString.RESPONSE_STRING_succesfullyAuthenticated,
              ),
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          message: isGenerateProof
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
                message: ResponseString
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

    String network = Parameters.POLYGON_MAIN_NETWORK;

    if (state.currentNetwork == PolygonIdNetwork.PolygonMainnet) {
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
    required QRCodeScanCubit qrCodeScanCubit,
    required Uri uri,
  }) async {
    try {
      log.i('add Claims');
      emit(state.copyWith(status: AppStatus.loading));
      for (int i = 0; i < state.claims!.length; i++) {
        await addToList(
          claimEntity: state.claims![i],
          credentialManifest: state.credentialManifests![i],
          qrCodeScanCubit: qrCodeScanCubit,
          uri: uri,
        );
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
                message: ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> addToList({
    required ClaimEntity claimEntity,
    required CredentialManifest credentialManifest,
    required QRCodeScanCubit qrCodeScanCubit,
    required Uri uri,
  }) async {
    final jsonCredential = claimEntity.info;
    final credentialPreview = Credential.fromJson(jsonCredential);

    final credentialModel = CredentialModel(
      id: claimEntity.id,
      image: 'image',
      data: jsonCredential,
      shareLink: '',
      jwt: null,
      format: 'ldp_vc',
      credentialPreview: credentialPreview,
      credentialManifest: credentialManifest,
      expirationDate: claimEntity.expiration,
      activities: [Activity(acquisitionAt: DateTime.now())],
      profileLinkedId: profileCubit.state.model.profileType.getVCId,
    );
    // insert the credential in the wallet
    await credentialsCubit.insertCredential(
        credential: credentialModel,
        blockchainType: walletCubit.state.currentAccount!.blockchainType,
        uri: uri);
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
    String network = Parameters.POLYGON_MAIN_NETWORK;

    if (state.currentNetwork == PolygonIdNetwork.PolygonMainnet) {
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
