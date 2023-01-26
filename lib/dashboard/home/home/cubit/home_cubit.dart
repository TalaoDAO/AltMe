import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:altme/wallet/model/crypto_account.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:crypto/crypto.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:web3dart/crypto.dart';
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

  final log = getLogger('HomeCubit');

  Future<void> aiSelfiValidation({
    required CredentialSubjectType credentialType,
    required List<int> imageBytes,
    required WalletCubit walletCubit,
    required CameraCubit cameraCubit,
  }) async {
    // launch url to get Over18,Over13,AgeRange Credentials
    emit(state.loading());
    final verificationMethod =
        await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

    final base64EncodedImage = base64Encode(imageBytes);

    final challenge =
        bytesToHex(sha256.convert(utf8.encode(base64EncodedImage)).bytes);

    final options = <String, dynamic>{
      'verificationMethod': verificationMethod,
      'proofPurpose': 'authentication',
      'challenge': challenge,
      'domain': 'issuer.talao.co',
    };

    final key = (await secureStorageProvider.get(SecureStorageKeys.ssiKey))!;
    final did = (await secureStorageProvider.get(SecureStorageKeys.did))!;

    final DIDKitProvider didKitProvider = DIDKitProvider();
    final String did_auth = await didKitProvider.didAuth(
      did,
      jsonEncode(options),
      key,
    );

    final data = <String, dynamic>{
      'base64_encoded_string': base64EncodedImage,
      'vp': did_auth,
      'did': did,
    };

    await dotenv.load();
    final YOTI_AI_API_KEY = dotenv.get('YOTI_AI_API_KEY');

    try {
      await _getCredentialByAI(
        url: Urls.over13AIValidationUrl,
        apiKey: YOTI_AI_API_KEY,
        data: data,
        credentialType: 'Over13',
        walletCubit: walletCubit,
        cameraCubit: cameraCubit,
      );

      await _getCredentialByAI(
        url: Urls.over18AIValidationUrl,
        apiKey: YOTI_AI_API_KEY,
        data: data,
        credentialType: 'Over18',
        walletCubit: walletCubit,
        cameraCubit: cameraCubit,
      );

      await _getCredentialByAI(
        url: Urls.ageRangeAIValidationUrl,
        apiKey: YOTI_AI_API_KEY,
        data: data,
        credentialType: 'AgeRange',
        walletCubit: walletCubit,
        cameraCubit: cameraCubit,
      );

      await _getCredentialByAI(
        url: 'https://issuer.talao.co/ai/ageestimate',
        apiKey: YOTI_AI_API_KEY,
        data: data,
        credentialType: 'AgeEstimate',
        walletCubit: walletCubit,
        cameraCubit: cameraCubit,
      );
    } catch (e) {
      final logger = getLogger('HomeCubit - AISelfiValidation');
      logger.e('error: $e');
    }
  }

  Future<void> _getCredentialByAI({
    required String url,
    required String apiKey,
    required Map<String, dynamic> data,
    required String credentialType,
    required WalletCubit walletCubit,
    required CameraCubit cameraCubit,
  }) async {
    final logger = getLogger('HomeCubit - AISelfiValidation');

    /// if credential of this type is already in the wallet do nothing
    /// Ensure credentialType = name of credential type in CredentialModel
    CredentialSubjectType credentialTypeEnum =
        CredentialSubjectType.aragoEmailPass;
    if (credentialType == 'AgeRange') {
      credentialTypeEnum = CredentialSubjectType.ageRange;
    }
    if (credentialType == 'Over13') {
      credentialTypeEnum = CredentialSubjectType.over13;
    }
    if (credentialType == 'Over18') {
      credentialTypeEnum = CredentialSubjectType.over18;
    }

    final List<CredentialModel> credentialList = await walletCubit
        .credentialListFromCredentialSubjectType(credentialTypeEnum);
    if (credentialList.isEmpty) {
      dynamic response;
      try {
        emit(state.copyWith(status: AppStatus.loading));
        response = await client.post(
          url,
          headers: <String, dynamic>{
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'X-API-KEY': apiKey,
          },
          data: data,
        );
      } catch (e) {
        if (e is NetworkException) {
          String? message;
          if (e.data != null) {
            if (e.data['error_description'] is String) {
              try {
                final dynamic errorDescriptionJson =
                    jsonDecode(e.data['error_description'] as String);
                message = errorDescriptionJson['error_message'] as String;
              } catch (_, __) {
                message = e.data['error_description'] as String;
              }
            } else if (e.data['error_description'] is Map<String, dynamic>) {
              message = e.data['error_description']['error_message'] as String;
            }
          }
          emit(
            state.copyWith(
              status: AppStatus.error,
              message: StateMessage(
                messageHandler: ResponseMessage(
                  ResponseString
                      .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
                ),
              ),
            ),
          );
          emit(
            state.copyWith(
              status: AppStatus.error,
              message: StateMessage(
                stringMessage: message,
                messageHandler: message == null
                    ? null
                    : ResponseMessage(
                        ResponseString
                            .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
                      ),
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AppStatus.error,
              message: StateMessage(
                messageHandler: ResponseMessage(
                  ResponseString
                      .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
                ),
              ),
            ),
          );
        }
      }
      try {
        if (response != null) {
          final credential =
              jsonDecode(response as String) as Map<String, dynamic>;

          final Map<String, dynamic> newCredential =
              Map<String, dynamic>.from(credential);
          newCredential['credentialPreview'] = credential;
          final CredentialManifest credentialManifest =
              await getCredentialManifestFromAltMe(client);
          credentialManifest.outputDescriptors
              ?.removeWhere((element) => element.id != credentialType);
          if (credentialManifest.outputDescriptors!.isNotEmpty) {
            newCredential['credential_manifest'] = CredentialManifest(
              credentialManifest.id,
              credentialManifest.issuedBy,
              credentialManifest.outputDescriptors,
              credentialManifest.presentationDefinition,
            ).toJson();
          }

          final credentialModel = CredentialModel.copyWithData(
            oldCredentialModel: CredentialModel.fromJson(
              newCredential,
            ),
            newData: credential,
            activities: [Activity(acquisitionAt: DateTime.now())],
          );
          if (credentialType != 'AgeEstimate') {
            await walletCubit.insertCredential(
              credential: credentialModel,
              showMessage: true,
            );
            await cameraCubit.incrementAcquiredCredentialsQuantity();
            emit(
              state.copyWith(
                status: AppStatus.success,
              ),
            );
          } else {
            await cameraCubit.updateAgeEstimate(
              credentialModel.data['credentialSubject']['ageEstimate']
                  as String,
            );
          }
        }
        logger.i('response : $response');
      } catch (e, s) {
        if (e is NetworkException) {
          String? message;
          if (e.data != null) {
            if (e.data['error_description'] is String) {
              try {
                final dynamic errorDescriptionJson =
                    jsonDecode(e.data['error_description'] as String);
                message = errorDescriptionJson['error_message'] as String;
              } catch (_, __) {
                message = e.data['error_description'] as String;
              }
            } else if (e.data['error_description'] is Map<String, dynamic>) {
              message = e.data['error_description']['error_message'] as String;
            }
          }
          emit(
            state.copyWith(
              status: AppStatus.error,
              message: StateMessage(
                stringMessage: message,
                messageHandler: message == null
                    ? null
                    : ResponseMessage(
                        ResponseString
                            .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
                      ),
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AppStatus.error,
              message: StateMessage(
                messageHandler: ResponseMessage(
                  ResponseString
                      .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
                ),
              ),
            ),
          );
        }
        logger.e('error: $e , stack: $s');
      }
    }
  }

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
    required Function() onPassBaseApproved,
  }) async {
    log.i('Checking PassbaseStatus');
    emit(state.loading());

    final passBaseStatus = await checkPassbaseStatus();

    if (passBaseStatus == PassBaseStatus.approved) {
      onPassBaseApproved.call();
    }

    if (passBaseStatus == PassBaseStatus.pending) {
      getPassBaseStatusBackground();
    }

    log.i(passBaseStatus);

    emit(
      state.copyWith(
        status: AppStatus.populate,
        passBaseStatus: passBaseStatus,
        link: link,
      ),
    );
  }

  Future<PassBaseStatus> checkPassbaseStatus() async {
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
      final did = didCubit.state.did!;
      passBaseStatus = await getPassBaseStatusFromAPI(did);
      await secureStorageProvider.set(
        SecureStorageKeys.passBaseStatus,
        passBaseStatus.name,
      );
    }
    emit(state.copyWith(status: AppStatus.populate));
    return passBaseStatus;
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
          await dotenv.load();
          final PASSBASE_WEBHOOK_AUTH_TOKEN =
              dotenv.get('PASSBASE_WEBHOOK_AUTH_TOKEN');
          final dynamic response = await client.post(
            '/wallet/webhook',
            headers: <String, dynamic>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $PASSBASE_WEBHOOK_AUTH_TOKEN',
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
    // We check passbase status during five minutes
    var timerCounter = 24;
    Timer.periodic(const Duration(seconds: 20), (timer) async {
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
          timer.cancel();
        }
      }
      timerCounter--;
      if (timerCounter == 0) {
        timer.cancel();
      }
    });
  }

  Future<void> periodicCheckRewardOnTezosBlockchain() async {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      List<String> walletAddresses = [];
      final String? savedCryptoAccount =
          await secureStorageProvider.get(SecureStorageKeys.cryptoAccount);

      if (savedCryptoAccount != null && savedCryptoAccount.isNotEmpty) {
        //load all the content of walletAddress
        final cryptoAccountJson =
            jsonDecode(savedCryptoAccount) as Map<String, dynamic>;
        final CryptoAccount cryptoAccount =
            CryptoAccount.fromJson(cryptoAccountJson);

        walletAddresses =
            cryptoAccount.data.map((e) => e.walletAddress).toList();
      }
      if (walletAddresses.isEmpty) return;
      try {
        final tezosWalletAddresses =
            walletAddresses.where((e) => e.startsWith('tz')).toList();
        if (tezosWalletAddresses.isEmpty) return;
        await checkRewards(tezosWalletAddresses);
      } catch (e, s) {
        getLogger('HomeCubit')
            .e('error in checking for reward , error: $e, stack: $s');
      }
    });
  }

  Future<void> checkRewards(List<String> walletAddresses) async {
    for (int i = 0; i < walletAddresses.length; i++) {
      await checkUNOReward(walletAddresses[i]);
      await checkXTZReward(walletAddresses[i]);
    }
  }

  Future<void> checkUNOReward(String walletAddress) async {
    getLogger('HomeCubit').i('check for UNO reward');
    final response = await client.get(
      '${Urls.tzktMainnetUrl}/v1/tokens/transfers',
      queryParameters: <String, dynamic>{
        'from': 'tz1YtKsJMx5FqhULTDzNxs9r9QYHBGsmz58o', // tezotopia
        'to': walletAddress,
        'token.contract.eq': 'KT1ErKVqEhG9jxXgUG2KGLW3bNM7zXHX8SDF', // UNO
        'sort.desc': 'timestamp'
      },
    ) as List<dynamic>;

    if (response.isEmpty) {
      return;
    }

    final operations = response
        .map(
          (dynamic e) => OperationModel.fromFa2Json(e as Map<String, dynamic>),
        )
        .toList();

    final String? lastNotifiedRewardId = await secureStorageProvider.get(
      SecureStorageKeys.lastNotifiedUNORewardId + walletAddress,
    );

    final lastOperation = operations.first; //operations sorted by time in api
    if (lastOperation.id.toString() == lastNotifiedRewardId) {
      return;
    } else {
      // save the operation id to storage
      await secureStorageProvider.set(
        SecureStorageKeys.lastNotifiedUNORewardId + walletAddress,
        lastOperation.id.toString(),
      );

      emit(
        state.copyWith(
          status: AppStatus.gotTokenReward,
          tokenReward: TokenReward(
            amount: lastOperation.calcAmount(
              decimal: 9, //UNO
              value: lastOperation.amount.toString(),
            ),
            txId: lastOperation.hash,
            counter: lastOperation.counter,
            account: walletAddress,
            origin:
                'Tezotopia Membership Card', // TODO(all): dynamic text later
            symbol: 'UNO',
            name: 'Unobtanium',
          ),
        ),
      );
    }
  }

  Future<void> checkXTZReward(String walletAddress) async {
    getLogger('HomeCubit').i('check for XTZ reward');

    final result = await client.get(
      '${Urls.tzktMainnetUrl}/v1/operations/transactions',
      queryParameters: <String, dynamic>{
        'sender': 'tz1YtKsJMx5FqhULTDzNxs9r9QYHBGsmz58o', // tezotopia
        'target': walletAddress,
        'amount.gt': 0,
      },
    ) as List<dynamic>;

    if (result.isEmpty) {
      return;
    }

    final operations = result
        .map(
          (dynamic e) => OperationModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    //sort for last transaction at first
    operations.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );

    final String? lastNotifiedRewardId = await secureStorageProvider.get(
      SecureStorageKeys.lastNotifiedXTZRewardId + walletAddress,
    );

    final lastOperation = operations.first; //operations sorted by time in api
    if (lastOperation.id.toString() == lastNotifiedRewardId) {
      return;
    } else {
      // save the operation id to storage
      await secureStorageProvider.set(
        SecureStorageKeys.lastNotifiedXTZRewardId + walletAddress,
        lastOperation.id.toString(),
      );

      emit(
        state.copyWith(
          status: AppStatus.gotTokenReward,
          tokenReward: TokenReward(
            amount: lastOperation.calcAmount(
              decimal: 6, //XTZ
              value: lastOperation.amount.toString(),
            ),
            account: walletAddress,
            txId: lastOperation.hash,
            counter: lastOperation.counter,
            origin:
                'Tezotopia Membership Card', // TODO(all): dynamic text later
            symbol: 'XTZ',
            name: 'Tezos',
          ),
        ),
      );
    }
  }
}

Future<PassBaseStatus> getPassBaseStatusFromAPI(String did) async {
  try {
    await dotenv.load();
    final PASSBASE_CHECK_DID_AUTH_TOKEN =
        dotenv.get('PASSBASE_CHECK_DID_AUTH_TOKEN');
    final client = DioClient(Urls.issuerBaseUrl, Dio());
    final dynamic response = await client.get(
      '/passbase/check/$did',
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $PASSBASE_CHECK_DID_AUTH_TOKEN',
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
