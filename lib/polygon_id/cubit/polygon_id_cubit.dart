import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
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
  }) : super(const PolygonIdState());

  final SecureStorageProvider secureStorageProvider;
  final PolygonId polygonId;
  final CredentialsCubit credentialsCubit;
  final DioClient client;

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
            status: PolygonIdStatus.idle,
            isInitialised: true,
          ),
        );
        return;
      }

      /// PolygonId SDK initialization
      await dotenv.load();

      await PolygonId().init(
        web3Url: dotenv.get('INFURA_URL'),
        web3RdpUrl: dotenv.get('INFURA_RDP_URL'),
        web3ApiKey: dotenv.get('INFURA_MUMBAI_API_KEY'),
        idStateContract: dotenv.get('ID_STATE_CONTRACT_ADDR'),
        pushUrl: dotenv.get('PUSH_URL'),
      );

      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      //addIdentity
      await polygonId.addIdentity(mnemonic: mnemonic!);
      emit(
        state.copyWith(
          status: PolygonIdStatus.init,
          isInitialised: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PolygonIdStatus.error,
          isInitialised: false,
        ),
      );
      throw Exception('INIT_ISSUE - $e');
    }
  }

  Future<void> downloadCircuits(String scannedResponse) async {
    try {
      await initialise();

      emit(
        state.copyWith(
          status: PolygonIdStatus.loading,
          scannedResponse: scannedResponse,
        ),
      );

      log.i('download circuit');
      //download circuit
      final isCircuitAlreadyDownloaded = await polygonId.isCircuitsDownloaded();
      if (isCircuitAlreadyDownloaded) {
        log.i('circuit already downloaded');
        emit(state.copyWith(status: PolygonIdStatus.alert));
      } else {
        // show loading with authentication message
        final Stream<DownloadInfo> stream =
            await polygonId.initCircuitsDownloadAndGetInfoStream;
        _subscription = stream.listen((DownloadInfo downloadInfo) async {
          if (downloadInfo.completed) {
            unawaited(_subscription?.cancel());
            log.i('download circuit complete');
            emit(state.copyWith(status: PolygonIdStatus.alert));
          } else {
            // loading value update
            final double loadedValue =
                downloadInfo.downloaded / downloadInfo.contentLength;
            final roundedValue = double.parse(loadedValue.toStringAsFixed(1));
            log.i(roundedValue);
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
        await polygonId.getIden3Message(message: state.scannedResponse!);
    return iden3MessageEntity;
  }

  Future<void> polygonActions() async {
    emit(state.copyWith(status: PolygonIdStatus.loading));
    final Iden3MessageEntity iden3MessageEntity =
        await getIden3Message(message: state.scannedResponse!);

    if (iden3MessageEntity.messageType == Iden3MessageType.auth) {
      final body = iden3MessageEntity.body as AuthBodyRequest;

      if (body.scope!.isEmpty) {
        log.i('issuer');
        emit(state.copyWith(status: PolygonIdStatus.issuer));
      } else {
        log.i('verifier');
        emit(state.copyWith(status: PolygonIdStatus.verifier));
      }
    } else if (iden3MessageEntity.messageType == Iden3MessageType.offer) {
      log.i('get claims');
      emit(state.copyWith(status: PolygonIdStatus.offer));
    } else {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
      );
    }
  }

  Future<void> authenticate(Iden3MessageEntity iden3MessageEntity) async {
    try {
      emit(state.copyWith(status: PolygonIdStatus.loading));
      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      log.i('polygonId authentication');
      final isAuthenticated = await polygonId.authenticate(
        iden3MessageEntity: iden3MessageEntity,
        mnemonic: mnemonic!,
      );

      if (isAuthenticated) {
        emit(
          state.copyWith(
            status: PolygonIdStatus.goBack,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_succesfullyAuthenticated,
              ),
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_authenticationFailed,
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

  Future<void> addPolygonIdCredentials({
    required List<ClaimEntity> claims,
  }) async {
    try {
      log.i('add Claims');
      emit(state.copyWith(status: PolygonIdStatus.loading));
      for (final claim in claims) {
        await addPolygonCredential(claim);
      }
      emit(state.copyWith(status: PolygonIdStatus.goBack));
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

  Future<void> addPolygonCredential(ClaimEntity claimEntity) async {
    final jsonCredential = claimEntity.info;
    final credentialPreview = Credential.fromJson(jsonCredential);

    CredentialManifest? credentialManifest;
    try {
      // Try to get Credential manifest for kycAgeCredential
      // and kycCountryOfResidence
      if (claimEntity.id == CredentialSubjectType.kycAgeCredential.name) {
        final response = await client.get(Urls.kycAgeCredentialUrl);
        credentialManifest =
            CredentialManifest.fromJson(response as Map<String, dynamic>);
      } else if (claimEntity.id ==
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
}
