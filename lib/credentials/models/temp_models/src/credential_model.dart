//ignore: must_be_immutable
import 'display_model.dart';
import 'm_credential.dart';
import 'enum/index.dart';

class CredentialModel {
  final String id;
  final String? alias;
  final String? image;
  final Map<String, dynamic> data;
  final String shareLink;
  final MCredential credentialPreview;
  final DisplayModel display;
  final String? expirationDate;
  RevocationStatus revocationStatus;

  CredentialModel({
    required this.id,
    required this.alias,
    required this.image,
    required this.credentialPreview,
    required this.shareLink,
    required this.display,
    required this.data,
    required this.revocationStatus,
    this.expirationDate,
  });

  String get issuer => data['issuer'] as String;

  Future<CredentialStatus> get status async {
    if (expirationDate != null) {
      DateTime? dateTimeExpirationDate = DateTime.parse(expirationDate!);
      if (!(dateTimeExpirationDate.isAfter(DateTime.now()))) {
        revocationStatus = RevocationStatus.expired;
        return CredentialStatus.expired;
      }
    }
    if (credentialPreview.credentialStatus.type != '') {
      return await checkRevocationStatus();
    } else {
      return CredentialStatus.active;
    }
  }

  Future<CredentialStatus> checkRevocationStatus() async {
    switch (revocationStatus) {
      case RevocationStatus.active:
        return CredentialStatus.active;
      case RevocationStatus.expired:
        revocationStatus = RevocationStatus.expired;
        return CredentialStatus.expired;
      case RevocationStatus.revoked:
        return CredentialStatus.revoked;
      // case RevocationStatus.unknown:
      //   var _status = await getRevocationStatus();
      //   switch (_status) {
      //     case RevocationStatus.active:
      //       return CredentialStatus.active;
      //     case RevocationStatus.expired:
      //       return CredentialStatus.expired;
      //     case RevocationStatus.revoked:
      //       return CredentialStatus.revoked;
      //     case RevocationStatus.unknown:
      //       throw Exception('Invalid status of credential');
      //   }
      default:
        throw Exception();
    }
  }
}