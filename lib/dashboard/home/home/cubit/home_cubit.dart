import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/dashboard/qr_code/qr_code.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:crypto/crypto.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:web3dart/crypto.dart';

part 'home_cubit.g.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.client,
    required this.secureStorageProvider,
    required this.oidc4vc,
    required this.profileCubit,
    required this.didKitProvider,
  }) : super(const HomeState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;
  final OIDC4VC oidc4vc;
  final ProfileCubit profileCubit;
  final DIDKitProvider didKitProvider;

  final log = getLogger('HomeCubit');

  Future<void> aiSelfiValidation({
    required CredentialSubjectType credentialType,
    required List<int> imageBytes,
    required CredentialsCubit credentialsCubit,
    required CameraCubit cameraCubit,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required BlockchainType blockchainType,
    required VCFormatType vcFormatType,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    // launch url to get Over18, Over15, Over13,Over21,Over50,Over65,
    // AgeRange Credentials
    emit(state.loading());

    final didKeyType = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;

    final privateKey = await getPrivateKey(
      profileCubit: profileCubit,
      didKeyType: didKeyType,
    );

    final (did, kid) = await getDidAndKid(
      didKeyType: didKeyType,
      privateKey: privateKey,
      profileCubit: profileCubit,
    );

    final base64EncodedImage = base64Encode(imageBytes);

    final challenge =
        bytesToHex(sha256.convert(utf8.encode(base64EncodedImage)).bytes);

    final options = <String, dynamic>{
      'verificationMethod': kid,
      'proofPurpose': 'authentication',
      'challenge': challenge,
      'domain': 'issuer.talao.co',
    };

    final String did_auth = await didKitProvider.didAuth(
      did,
      jsonEncode(options),
      privateKey,
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
        url: credentialType.aiValidationUrl,
        apiKey: YOTI_AI_API_KEY,
        data: data,
        credentialSubjectType: credentialType,
        credentialsCubit: credentialsCubit,
        cameraCubit: cameraCubit,
        oidc4vciDraftType: oidc4vciDraftType,
        blockchainType: blockchainType,
        vcFormatType: vcFormatType,
        qrCodeScanCubit: qrCodeScanCubit,
      );

      await ageEstimate(
        url: 'https://issuer.talao.co/ai/ageestimate',
        apiKey: YOTI_AI_API_KEY,
        data: data,
        cameraCubit: cameraCubit,
      );
    } catch (e) {
      final logger = getLogger('HomeCubit - AISelfiValidation');
      logger.e('error: $e');

      logger.e(e);
      String? message;
      if (e is NetworkException) {
        if (e.data != null) {
          if (e.data['error_description'] != null) {
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
        }
      }
      emit(
        state.copyWith(
          status: AppStatus.error,
          message: StateMessage(
            showDialog: !(message == null),
            stringMessage: message,
            messageHandler: message == null
                ? ResponseMessage(
                    message: ResponseString
                        .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
                  )
                : null,
          ),
        ),
      );
    }
  }

  Future<void> _getCredentialByAI({
    required String url,
    required String apiKey,
    required Map<String, dynamic> data,
    required CredentialSubjectType credentialSubjectType,
    required CredentialsCubit credentialsCubit,
    required CameraCubit cameraCubit,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required BlockchainType blockchainType,
    required VCFormatType vcFormatType,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    /// if credential of this type is already in the wallet do nothing
    /// Ensure credentialType = name of credential type in CredentialModel

    final List<CredentialModel> credentialList = await credentialsCubit
        .credentialListFromCredentialSubjectType(credentialSubjectType);
    if (credentialList.isEmpty) {
      dynamic response;

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

      if (response != null) {
        final credential =
            jsonDecode(response as String) as Map<String, dynamic>;

        final Map<String, dynamic> newCredential =
            Map<String, dynamic>.from(credential);
        newCredential['credentialPreview'] = credential;
        newCredential['format'] = vcFormatType.vcValue;
        final CredentialManifest credentialManifest =
            await getCredentialManifestFromAltMe(
          oidc4vc: oidc4vc,
          oidc4vciDraftType: oidc4vciDraftType,
        );
        credentialManifest.outputDescriptors?.removeWhere(
          (element) => element.id != credentialSubjectType.name,
        );
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
        await credentialsCubit.insertCredential(
          credential: credentialModel,
          showMessage: true,
          blockchainType: blockchainType,
          qrCodeScanCubit: qrCodeScanCubit,
        );
        await cameraCubit.incrementAcquiredCredentialsQuantity();
        emit(state.copyWith(status: AppStatus.success));
      }
    }
  }

  Future<void> ageEstimate({
    required String url,
    required String apiKey,
    required Map<String, dynamic> data,
    required CameraCubit cameraCubit,
  }) async {
    dynamic response;

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

    if (response != null) {
      final credential = jsonDecode(response as String) as Map<String, dynamic>;
      await cameraCubit.updateAgeEstimate(
        credential['credentialSubject']['ageEstimate'] as String,
      );
    }
  }

  Future<void> emitHasWallet() async {
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
}
