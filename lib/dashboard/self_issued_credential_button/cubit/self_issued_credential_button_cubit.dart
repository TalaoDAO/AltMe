import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/dashboard/self_issued_credential_button/models/self_issued_credential.dart';

import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'self_issued_credential_button_cubit.g.dart';
part 'self_issued_credential_button_state.dart';

class SelfIssuedCredentialCubit extends Cubit<SelfIssuedCredentialButtonState> {
  SelfIssuedCredentialCubit({
    required this.credentialsCubit,
    required this.secureStorageProvider,
    required this.didKitProvider,
    required this.profileCubit,
    required this.oidc4vc,
  }) : super(const SelfIssuedCredentialButtonState());

  final CredentialsCubit credentialsCubit;

  final SecureStorageProvider secureStorageProvider;
  final DIDKitProvider didKitProvider;
  final ProfileCubit profileCubit;
  final OIDC4VC oidc4vc;

  Future<void> createSelfIssuedCredential({
    required SelfIssuedCredentialDataModel selfIssuedCredentialDataModel,
  }) async {
    final log =
        getLogger('SelfIssuedCredentialCubit - createSelfIssuedCredential');
    try {
      emit(state.loading());
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final didKeyType = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;

      final privateKey = await getPrivateKey(
        secureStorage: getSecureStorage,
        didKeyType: didKeyType,
        oidc4vc: oidc4vc,
      );

      final (did, kid) = await getDidAndKid(
        didKeyType: didKeyType,
        privateKey: privateKey,
        secureStorage: getSecureStorage,
        didKitProvider: didKitProvider,
      );

      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': kid,
      };

      final verifyOptions = {'proofPurpose': 'assertionMethod'};
      final id = 'urn:uuid:${const Uuid().v4()}';
      final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
      final issuanceDate = '${formatter.format(DateTime.now())}Z';

      final selfIssued = SelfIssuedModel(
        id: did,
        address: selfIssuedCredentialDataModel.address,
        familyName: selfIssuedCredentialDataModel.familyName,
        givenName: selfIssuedCredentialDataModel.givenName,
        telephone: selfIssuedCredentialDataModel.telephone,
        email: selfIssuedCredentialDataModel.email,
        workFor: selfIssuedCredentialDataModel.companyName,
        companyWebsite: selfIssuedCredentialDataModel.companyWebsite,
        jobTitle: selfIssuedCredentialDataModel.jobTitle,
      );

      final selfIssuedCredential = SelfIssuedCredential(
        id: id,
        issuer: did,
        issuanceDate: issuanceDate,
        credentialSubjectModel: selfIssued,
      );

      await Future<void>.delayed(const Duration(milliseconds: 500));
      final vc = await didKitProvider.issueCredential(
        jsonEncode(selfIssuedCredential.toJson()),
        jsonEncode(options),
        privateKey,
      );
      final result =
          await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
      final jsonVerification = jsonDecode(result) as Map<String, dynamic>;

      log.i('vc: $vc');
      log.i('verifyResult: $jsonVerification');

      if ((jsonVerification['warnings'] as List<dynamic>).isNotEmpty) {
        log.w(
          'credential verification return warnings',
          error: jsonVerification['warnings'],
        );
      }

      if ((jsonVerification['errors'] as List<dynamic>).isNotEmpty) {
        log.e('failed to verify credential', error: jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          throw ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL,
          );
        } else {
          await _recordCredential(vc);
        }
      } else {
        await _recordCredential(vc);
      }
      emit(state.success());
    } catch (e, s) {
      log.e('something went wrong', error: e, stackTrace: s);
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_FAILED_TO_CREATE_SELF_ISSUED_CREDENTIAL,
            ),
          ),
        );
      }
    }
  }

  Future<void> _recordCredential(String vc) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final jsonCredential = jsonDecode(vc) as Map<String, dynamic>;
    final id = 'urn:uuid:${const Uuid().v4()}';
    final credentialModel = CredentialModel(
      id: id,
      image: 'image',
      data: jsonCredential,
      shareLink: '',
      jwt: null,
      format: 'ldp_vc',
      credentialPreview: Credential.fromJson(jsonCredential),
      activities: [Activity(acquisitionAt: DateTime.now())],
    );
    await credentialsCubit.insertCredential(credential: credentialModel);
    emit(
      state.success(
        messageHandler: ResponseMessage(
          message:
              ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY,
        ),
      ),
    );
  }
}
