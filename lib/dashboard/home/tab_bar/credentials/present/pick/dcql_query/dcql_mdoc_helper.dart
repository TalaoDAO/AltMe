import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:crypto/crypto.dart';
import 'package:dcql/dcql.dart';
import 'package:mdoc/mdoc.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

/// The DCQL view of a stored mso_mdoc credential, or `null` when it is not
/// one.
MdocDigitalCredential? mdocDigitalCredential(CredentialModel credential) {
  final docType = credential.mdocDocType;
  final subject = credential.data['credentialSubject'];
  if (!credential.isMdoc || docType == null || subject is! Map) return null;
  return MdocDigitalCredential(
    docType: docType,
    nameSpaces: {
      for (final entry in subject.entries)
        if (entry.value is Map)
          entry.key.toString(): Map<String, dynamic>.from(entry.value as Map),
    },
  );
}

/// The OpenID4VP 1.0 SessionTranscript of the request in [uri] (its query
/// carries the resolved request parameters).
///
/// For `direct_post.jwt`, [clientMetadata] gives the verifier's keys, and the
/// thumbprint of the one the response is encrypted to is bound in.
List<Object?> oid4vpSessionTranscript({
  required Uri uri,
  Map<String, dynamic>? clientMetadata,
}) {
  final parameters = uri.queryParameters;
  Uint8List? jwkThumbprint;
  if (parameters['response_mode'] == 'direct_post.jwt' &&
      clientMetadata != null) {
    jwkThumbprint = SessionTranscript.jwkThumbprint(
      directPostEncryptionJwk(ClientMetadata.fromJson(clientMetadata)),
    );
  }
  return SessionTranscript.oid4vp(
    clientId: parameters['client_id'] ?? '',
    nonce: parameters['nonce'] ?? '',
    responseUri: parameters['response_uri'] ?? parameters['redirect_uri'] ?? '',
    jwkThumbprint: jwkThumbprint,
  );
}

/// The base64url DeviceResponse disclosing [requestedPaths] (DCQL claim
/// paths, `[namespace, element]`) of the mdoc [credential], with DeviceAuth
/// signed by its platform key over [sessionTranscript].
Future<String> buildMdocPresentation({
  required CredentialModel credential,
  required List<List<dynamic>> requestedPaths,
  required List<Object?> sessionTranscript,
  PlatformP256Keys platformKeys = const PlatformP256Keys(),
}) async {
  final issuerSigned = credential.mdocIssuerSigned;
  final keyId = credential.keyId;
  if (issuerSigned == null || keyId == null) {
    throw StateError('mdoc ${credential.id} has no IssuerSigned or key');
  }

  final elements = <String, List<String>>{};
  for (final path in requestedPaths) {
    if (path.length == 2 && path[0] is String && path[1] is String) {
      elements.putIfAbsent(path[0] as String, () => []).add(path[1] as String);
    }
  }

  final deviceResponse = await DeviceResponse.build(
    disclosures: [
      MdocDisclosure(
        issuerSigned: IssuerSigned.fromBase64Url(issuerSigned),
        elements: elements,
        signer: (toBeSigned) => platformKeys.signDigest(
          keyId,
          Uint8List.fromList(sha256.convert(toBeSigned).bytes),
        ),
      ),
    ],
    sessionTranscript: sessionTranscript,
  );
  return base64Url.encode(deviceResponse).replaceAll('=', '');
}
