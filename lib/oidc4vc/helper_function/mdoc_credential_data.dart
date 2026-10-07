import 'package:altme/app/app.dart';
import 'package:mdoc/mdoc.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';
import 'package:uuid/uuid.dart';

/// The alias of a fresh platform key for one mso_mdoc credential.
///
/// The key is created in the Android Keystore / Secure Enclave under this
/// alias, signs the OID4VCI proof, and is recorded as the credential's
/// `keyId`: OID4VP DeviceAuth and proximity presentation sign with it too.
String newMdocKeyAlias() => 'mdoc_${const Uuid().v4()}';

/// The `CredentialModel` data of an mso_mdoc credential, from the base64url
/// `IssuerSigned` an OID4VCI credential response carries.
///
/// The data elements go under `credentialSubject`, keyed by name space, so
/// issuer metadata claim paths (`[namespace, element]`) resolve against them.
/// The raw `issuerSigned` is kept for presentation.
///
/// Rejects an mdoc whose elements do not match the MSO digests, or that is
/// not bound to the platform key [keyId] when there is one.
Future<Map<String, dynamic>> getMdocCredentialData({
  required String issuerSigned,
  required String credentialType,
  String? keyId,
  PlatformP256Keys platformKeys = const PlatformP256Keys(),
}) async {
  final IssuerSigned mdoc;
  try {
    mdoc = IssuerSigned.fromBase64Url(issuerSigned);
  } on FormatException catch (e) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description': 'The mso_mdoc credential cannot be decoded: $e',
      },
    );
  }

  if (!mdoc.digestsMatch()) {
    throw ResponseMessage(
      data: {
        'error': 'invalid_format',
        'error_description':
            'The mso_mdoc data elements do not match the MSO digests.',
      },
    );
  }

  if (keyId != null) {
    final key = await platformKeys.find(keyId);
    if (key != null && !mdoc.isBoundTo(key.publicKey)) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description':
              'The mso_mdoc is not bound to the key sent in the proof.',
        },
      );
    }
  }

  return {
    'id': 'urn:uuid:${const Uuid().v4()}',
    'type': [credentialType],
    'issuanceDate': mdoc.mso.signed.toIso8601String(),
    'expirationDate': mdoc.mso.validUntil.toIso8601String(),
    'credentialSubject': {'type': credentialType, ...mdoc.claims()},
    'docType': mdoc.docType,
    'issuerSigned': issuerSigned,
  };
}
