import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/bottom_bar/self_issued_credential_button/models/self_issued_credential.dart';
import 'package:altme/home/home.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'self_issued_credential_button_cubit.g.dart';
part 'self_issued_credential_button_state.dart';

class SelfIssuedCredentialCubit extends Cubit<SelfIssuedCredentialButtonState> {
  SelfIssuedCredentialCubit({
    required this.walletCubit,
    required this.secureStorageProvider,
    required this.didCubit,
    required this.didKitProvider,
  }) : super(const SelfIssuedCredentialButtonState());

  final WalletCubit walletCubit;
  final DIDCubit didCubit;
  final SecureStorageProvider secureStorageProvider;
  final DIDKitProvider didKitProvider;

  Future<void> createSelfIssuedCredential({
    required SelfIssuedCredentialDataModel selfIssuedCredentialDataModel,
  }) async {
    final log = Logger('altme/sef_issued_credential/create');
    try {
      emit(state.loading());
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final key = (await secureStorageProvider.get(SecureStorageKeys.key))!;
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      final did = didCubit.state.did!;

      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': verificationMethod
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
        key,
      );
      final result =
          await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
      final jsonVerification = jsonDecode(result) as Map<String, dynamic>;

      log.info('vc: $vc');
      log.info('verifyResult: ${jsonVerification.toString()}');

      if ((jsonVerification['warnings'] as List<dynamic>).isNotEmpty) {
        log.warning(
          'credential verification return warnings',
          jsonVerification['warnings'],
        );
      }

      if ((jsonVerification['errors'] as List<dynamic>).isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          throw ResponseMessage(
            ResponseString
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
      debugPrint('e: $e,s: $s');
      log.severe('something went wrong', e, s);
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
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
      alias: '',
      image: 'image',
      data: jsonCredential,
      display: Display.emptyDisplay()..toJson(),
      shareLink: '',
      credentialPreview: Credential.fromJson(jsonCredential),
      revocationStatus: RevocationStatus.unknown,
    );
    await walletCubit.insertCredential(credentialModel);
    emit(
      state.success(
        messageHandler: ResponseMessage(
          ResponseString.RESPONSE_STRING_SELF_ISSUED_CREATED_SUCCESSFULLY,
        ),
      ),
    );
  }
}
