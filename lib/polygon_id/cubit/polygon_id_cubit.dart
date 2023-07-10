import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
import 'package:web3dart/web3dart.dart';

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
        await polygonId.init(
          network: network,
          web3Url: Parameters.INFURA_URL,
          web3RdpUrl: Parameters.INFURA_RDP_URL,
          web3ApiKey: dotenv.get('INFURA_API_KEY'),
          idStateContract: Parameters.ID_STATE_CONTRACT_ADDR,
          pushUrl: Parameters.PUSH_URL,
          ipfsUrl: ipfsUrl,
        );
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
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
      emit(state.copyWith(status: AppStatus.init, isInitialised: true));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, isInitialised: false));
      throw Exception('INIT_ISSUE - $e');
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
          web3Url: Parameters.INFURA_URL,
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
      emit(state.copyWith(status: AppStatus.idle));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
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
      log.i('get claims');
      emit(
        state.copyWith(
          status: AppStatus.loading,
          polygonAction: PolygonIdAction.offer,
        ),
      );
    } else if (iden3MessageEntity.messageType ==
        Iden3MessageType.proofContractInvokeRequest) {
      log.i('contractFunctionCall verifier');
      final bodys = iden3MessageEntity.body as ContractFunctionCallBodyRequest;
      log.i(bodys.transactionData.toString());
      emit(
        state.copyWith(
          status: AppStatus.loading,
          polygonAction: PolygonIdAction.verifier,
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
  }) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      if (iden3MessageEntity.messageType == Iden3MessageType.authRequest) {
        final body = iden3MessageEntity.body as AuthBodyRequest;

        bool isGenerateProof = false;

        if (body.scope!.isEmpty) {
          log.i('issuer');
          isGenerateProof = false;
        } else {
          log.i('verifier');
          isGenerateProof = true;
        }

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
                  isGenerateProof
                      ? ResponseString
                          .RESPONSE_STRING_successfullyGeneratingProof
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
      } else if (iden3MessageEntity.messageType ==
          Iden3MessageType.proofContractInvokeRequest) {
        log.i('contractFunctionCall ');

        final Iden3MessageEntity iden3MessageEntity =
            await getIden3Message(message: state.scannedResponse!);

        final currentAccount = walletCubit.state.currentAccount;

        if (currentAccount == null) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }

        if (currentAccount.blockchainType == BlockchainType.tezos) {
          // TODO(bibash): throw correct error
          print('Not compatible');
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }

        final body = iden3MessageEntity.body as ContractFunctionCallBodyRequest;

        final mnemonic =
            await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

        final polygonIdNetwork =
            await getSecureStorage.get(SecureStorageKeys.polygonIdNetwork);

        String network = Parameters.POLYGON_MAIN_NETWORK;

        if (polygonIdNetwork == PolygonIdNetwork.PolygonMainnet.toString()) {
          network = Parameters.POLYGON_MAIN_NETWORK;
        } else {
          network = Parameters.POLYGON_TEST_NETWORK;
        }

        final walletAddress = currentAccount.walletAddress;
        final hexdata = await polygonId.generateProofByContractFunctionCall(
          contractIden3messageEntity: iden3MessageEntity,
          mnemonic: mnemonic!,
          network: network,
          walletAddress: walletAddress,
        );

        log.i('hexdata - $hexdata');

        final transaction = Transaction(
          from: EthereumAddress.fromHex(currentAccount.walletAddress),
          to: EthereumAddress.fromHex(body.transactionData.contractAddress),
          value: EtherAmount.fromBigInt(EtherUnit.wei, BigInt.zero),
          data: Uint8List.fromList(utf8.encode(hexdata)),
        );

        log.i('transaction - $transaction');

        emit(
          state.copyWith(
            status: AppStatus.loading,
            polygonAction: PolygonIdAction.contractFunctionCall,
            transaction: transaction,
          ),
        );
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
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
      // and kycCountryOfResidence and proofOfTwitterStatsUrl
      if (claimEntity.type == CredentialSubjectType.kycAgeCredential.name) {
        final response = await client.get(Urls.kycAgeCredentialUrl);
        credentialManifest =
            CredentialManifest.fromJson(response as Map<String, dynamic>);
      } else if (claimEntity.type ==
          CredentialSubjectType.kycCountryOfResidence.name) {
        final response = await client.get(Urls.kycCountryOfResidenceUrl);
        credentialManifest =
            CredentialManifest.fromJson(response as Map<String, dynamic>);
      } else if (claimEntity.type ==
          CredentialSubjectType.proofOfTwitterStats.name) {
        final response = await client.get(Urls.proofOfTwitterStatsUrl);
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
}
