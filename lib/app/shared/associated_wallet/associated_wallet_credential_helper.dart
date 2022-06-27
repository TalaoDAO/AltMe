import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/associated_wallet/associated_wallet_credential.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:did_kit/did_kit.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

class AssociatedWalletCredentialHelper {
  AssociatedWalletCredentialHelper({
    required this.secureStorageProvider,
    required this.didCubit,
    required this.didKitProvider,
  });

  final DIDCubit didCubit;
  final SecureStorageProvider secureStorageProvider;
  final DIDKitProvider didKitProvider;

  Future<CredentialModel?> generateAssociatedWalletCredential({
    required String accountName,
    required String walletAddress,
  }) async {
    final log = Logger('altme/associated_wallet_credential/create');
    try {
      final secretKey = await secureStorageProvider.get(
        SecureStorageKeys.ssiKey,
      );

      final did = didCubit.state.did!;

      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': didCubit.state.verificationMethod
      };
      final verifyOptions = {'proofPurpose': 'assertionMethod'};
      final id = 'urn:uuid:${const Uuid().v4()}';
      final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
      final issuanceDate = '${formatter.format(DateTime.now())}Z';

      final selfIssued = TezosAssociatedAddressModel(
        id: did,
        accountName: accountName,
        associatedAddress: walletAddress,
      );

      final selfIssuedCredential = AssociatedWalletCredential(
        id: id,
        issuer: did,
        issuanceDate: issuanceDate,
        credentialSubjectModel: selfIssued,
      );

      final vc = await didKitProvider.issueCredential(
        jsonEncode(selfIssuedCredential.toJson()),
        jsonEncode(options),
        secretKey!,
      );
      final result =
          await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
      final jsonVerification = jsonDecode(result) as Map<String, dynamic>;

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
          return _createCredential(vc);
        }
      } else {
        return _createCredential(vc);
      }
    } catch (e, s) {
      log.severe('something went wrong e: $e, stackTrace: $s', e, s);
      return null;
    }
  }

  Future<CredentialModel> _createCredential(String vc) async {
    final jsonCredential = jsonDecode(vc) as Map<String, dynamic>;
    final id = 'urn:uuid:${const Uuid().v4()}';
    return CredentialModel(
      id: id,
      alias: '',
      image: 'image',
      data: jsonCredential,
      display: Display.emptyDisplay()..toJson(),
      shareLink: '',
      credentialPreview: Credential.fromJson(jsonCredential),
      revocationStatus: RevocationStatus.unknown,
    );
  }
}
