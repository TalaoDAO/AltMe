import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/get_identity_credentials/get_multiple_credentials.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:workmanager/workmanager.dart';

part 'home_cubit.g.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.client,
    required this.didCubit,
    required this.secureStorageProvider,
  }) : super(const HomeState());

  final DioClient client;
  final DIDCubit didCubit;
  final SecureStorageProvider secureStorageProvider;

  Future<void> emitHasWallet() async {
    final String? passbaseStatusFromStorage = await secureStorageProvider.get(
      SecureStorageKeys.passBaseStatus,
    );
    if (passbaseStatusFromStorage != null) {
      final passBaseStatus = getPassBaseStatusFromString(
        passbaseStatusFromStorage,
      );
      if (passBaseStatus == PassBaseStatus.pending) {
        getPassBaseStatusBackground();
      }
    }

    emit(
      state.copyWith(
        status: AppStatus.populate,
        homeStatus: HomeStatus.hasWallet,
      ),
    );
  }

  void emitHasNoWallet() {
    emit(
      state.copyWith(
        status: AppStatus.populate,
        homeStatus: HomeStatus.hasNoWallet,
      ),
    );
  }

  Future<void> launchUrl({String? link}) async {
    await LaunchUrl.launch(link ?? state.link!);
  }

  Future<void> checkForPassBaseStatusThenLaunchUrl({
    required String link,
  }) async {
    emit(state.loading());

    late PassBaseStatus passBaseStatus;

    /// check if status is already approved in DB
    final String? passbaseStatusFromStorage = await secureStorageProvider.get(
      SecureStorageKeys.passBaseStatus,
    );

    if (passbaseStatusFromStorage != null) {
      passBaseStatus = getPassBaseStatusFromString(passbaseStatusFromStorage);
    } else {
      passBaseStatus = PassBaseStatus.undone;
    }
    if (passBaseStatus != PassBaseStatus.approved) {
      try {
        final did = didCubit.state.did!;
        passBaseStatus = await getPassBaseStatus(did);
        await secureStorageProvider.set(
          SecureStorageKeys.passBaseStatus,
          passBaseStatus.name,
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: AppStatus.populate,
            passBaseStatus: PassBaseStatus.declined,
            link: link,
          ),
        );
      }
    }

    if (passBaseStatus == PassBaseStatus.approved) {
      await launchUrl(link: link);
    }

    if (passBaseStatus == PassBaseStatus.pending) {
      getPassBaseStatusBackground();
    }

    emit(
      state.copyWith(
        status: AppStatus.populate,
        passBaseStatus: passBaseStatus,
        link: link,
      ),
    );
  }

  void startPassbaseVerification(WalletCubit walletCubit) {
    final log = getLogger('HomeCubit - startPassbaseVerification');
    final did = didCubit.state.did!;
    emit(state.loading());
    PassbaseSDK.startVerification(
      onFinish: (identityAccessKey) async {
        // IdentityAccessKey to run the process manually:
        // 22a363e6-2f93-4dd3-9ac8-6cba5a046acd

        unawaited(
          getMutipleCredentials(
            identityAccessKey,
            client,
            walletCubit,
            secureStorageProvider,
          ),
        );

        /// Do not remove: Following POST tell backend the relation between DID
        /// and passbase token.
        try {
          final dynamic response = await client.post(
            '/wallet/webhook',
            headers: <String, dynamic>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer mytoken',
            },
            data: <String, dynamic>{
              'identityAccessKey': identityAccessKey,
              'DID': did,
            },
          );

          if (response == 'ok') {
            emit(
              state.copyWith(
                status: AppStatus.idle,
                passBaseStatus: PassBaseStatus.complete,
              ),
            );
          } else {
            throw Exception();
          }
        } catch (e) {
          emit(
            state.copyWith(
              status: AppStatus.populate,
              passBaseStatus: PassBaseStatus.declined,
            ),
          );
        }
      },
      onError: (e) {
        if (e == 'CANCELLED_BY_USER') {
          log.e('Cancelled by user');
        } else {
          log.e('Unknown error');
        }
        emit(
          state.copyWith(
            status: AppStatus.idle,
            passBaseStatus: PassBaseStatus.idle,
          ),
        );
      },
    );
  }

  /// Give user metadata to KYC. Currently we are just sending user DID.
  bool setKYCMetadata(WalletCubit walletCubit) {
    final selectedCredentials = <CredentialModel>[];
    for (final credentialModel in walletCubit.state.credentials) {
      final credentialTypeList = credentialModel.credentialPreview.type;

      ///credential and issuer provided in claims
      if (credentialTypeList.contains('EmailPass')) {
        final credentialSubjectModel = credentialModel
            .credentialPreview.credentialSubjectModel as EmailPassModel;
        if (credentialSubjectModel.passbaseMetadata != '') {
          selectedCredentials.add(credentialModel);
        }
      }
    }
    if (selectedCredentials.isNotEmpty) {
      final firstEmailPassCredentialSubject =
          selectedCredentials.first.credentialPreview.credentialSubjectModel;
      if (firstEmailPassCredentialSubject is EmailPassModel) {
        /// Give user email from first EmailPass to KYC. When KYC is successful
        /// this email is used to send the over18 credential link to user.

        PassbaseSDK.prefillUserEmail = firstEmailPassCredentialSubject.email;
        PassbaseSDK.metaData = firstEmailPassCredentialSubject.passbaseMetadata;
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void getPassBaseStatusBackground() {
    final did = didCubit.state.did!;
    Workmanager().registerOneOffTask(
      'getPassBaseStatusBackground',
      'getPassBaseStatusBackground',
      inputData: <String, dynamic>{'did': did},
    );
    periodicCheckPassBaseStatus();
  }

  Future<void> periodicCheckPassBaseStatus() async {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      final String? passbaseStatusFromStorage = await secureStorageProvider.get(
        SecureStorageKeys.passBaseStatus,
      );

      if (passbaseStatusFromStorage != null) {
        final passBaseStatus = getPassBaseStatusFromString(
          passbaseStatusFromStorage,
        );
        if (passBaseStatus == PassBaseStatus.approved) {
          emit(
            state.copyWith(
              status: AppStatus.populate,
              passBaseStatus: PassBaseStatus.approved,
            ),
          );
        }
      }
    });
  }
}

Future<PassBaseStatus> getPassBaseStatus(String did) async {
  try {
    final client = DioClient(Urls.issuerBaseUrl, Dio());
    final dynamic response = await client.get(
      '/passbase/check/$did',
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Authorization': 'Bearer mytoken',
      },
    );
    final PassBaseStatus passBaseStatus = getPassBaseStatusFromString(
      response as String,
    );
    return passBaseStatus;
  } catch (e) {
    return PassBaseStatus.undone;
  }
}

PassBaseStatus getPassBaseStatusFromString(String? string) {
  late PassBaseStatus passBaseStatus;
  switch (string) {
    case 'approved':
      passBaseStatus = PassBaseStatus.approved;
      break;
    case 'declined':
      passBaseStatus = PassBaseStatus.declined;
      break;
    case 'verified':
      passBaseStatus = PassBaseStatus.verified;
      break;
    case 'pending':
      passBaseStatus = PassBaseStatus.pending;
      break;
    case 'undone':
      passBaseStatus = PassBaseStatus.undone;
      break;
    case 'notdone':
      passBaseStatus = PassBaseStatus.undone;
      break;
    case 'complete':
      passBaseStatus = PassBaseStatus.complete;
      break;
    case 'idle':
    default:
      passBaseStatus = PassBaseStatus.idle;
  }
  return passBaseStatus;
}
