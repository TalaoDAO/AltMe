import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:dcql/dcql.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:selective_disclosure_jwt/selective_disclosure_jwt.dart';

// Map the DCQL-matched DigitalCredential objects back to your original
// candidate (which still has the raw jwt string), using identity equality
// — same trick you already use.
SdJwtDigitalCredential? findOriginal(
  DigitalCredential matched,
  List<SdJwtDigitalCredential> packageFormatCredentials,
) => packageFormatCredentials.firstWhere((e) => identical(e, matched));

// Resolve a DCQL path (which may contain `null` wildcards) against the
// actual claims tree, returning the *concrete* path that was matched.
List<dynamic>? resolveConcretePath(
  dynamic current,
  List<dynamic> remaining,
  List<dynamic> acc,
) {
  if (remaining.isEmpty) return acc;
  if (current == null) return null;
  final head = remaining.first;
  final rest = remaining.sublist(1);

  if (current is Map<String, dynamic>) {
    if (!current.containsKey(head)) return null;
    return resolveConcretePath(current[head], rest, [...acc, head]);
  }
  if (current is List) {
    if (head == null) {
      for (var i = 0; i < current.length; i++) {
        final resolved = resolveConcretePath(current[i], rest, [...acc, i]);
        if (resolved != null) return resolved;
      }
      return null;
    } else if (head is int && head >= 0 && head < current.length) {
      return resolveConcretePath(current[head], rest, [...acc, head]);
    }
  }
  return null;
}

DisclosurePath buildDisclosurePath(List<dynamic> concretePath) {
  var p = DisclosurePath.root();
  for (final seg in concretePath) {
    p = p.segment(seg.toString());
  }
  return p;
}

Future<String> buildPresentation({
  required CredentialModel credential,
  required List<List<dynamic>> requestedPaths, // from DcqlClaim.path
  required Uri uri,
  required Map<String, dynamic> privateKey,
  required ProofHeaderType proofHeaderType,
}) async {
  final sdJwt = SelectiveDisclosure(credential);

  final encryptedValues = credential.jwt
      ?.split('~')
      .where((element) => element.isNotEmpty)
      .toList();

  String newJwt = '${encryptedValues![0]}~';
  for (final path in requestedPaths) {
    final disclosure = sdJwt.getSdFromKey(path[0] as String);
    if (disclosure != null) newJwt = '$newJwt$disclosure~';
  }

  // A Key Binding JWT is REQUIRED by the SD-JWT VC presentation format
  // whenever the credential carries a holder-binding key (`cnf`).
  if (credential.data['cnf'] != null) {
    final tokenParameters = TokenParameters(
      privateKey: privateKey,
      did: '', // not used for the embedded-jwk KB-JWT header
      mediaType: MediaType.selectiveDisclosure,
      clientType: ClientType.p256JWKThumprint,
      proofHeaderType: proofHeaderType,
      clientId: '', // not used for the embedded-jwk KB-JWT header
    );

    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final sdHash = sh256Hash(newJwt);

    final kbPayload = {
      'nonce': uri.queryParameters['nonce'] ?? '',
      'aud': uri.queryParameters['client_id'] ?? '',
      'iat': iat,
      'sd_hash': sdHash,
    };

    final kbJwt = generateToken(
      payload: kbPayload,
      tokenParameters: tokenParameters,
      ignoreProofHeaderType: true,
    );

    newJwt = '$newJwt$kbJwt';
  }

  return newJwt;
}

// --- Build the vp_token itself ---
Future<Map<String, List<String>>> buildVpToken(
  DcqlQueryResult result,
  List<SdJwtDigitalCredential> packageFormatCredentials,
  List<CredentialModel> candidates, // your wallet-side objects, same order
  Uri uri,
  Map<String, dynamic> privateKey,
  ProofHeaderType proofHeaderType,
) async {
  final vpToken = <String, List<String>>{};

  for (final entry in result.verifiableCredentials.entries) {
    final queryId = entry.key;
    final matchedList = entry.value;

    final requestedPaths = result.query.credentials
        .firstWhere((c) => c.id == queryId)
        .claims!
        .map((c) => c.path)
        .toList();

    final presentations = <String>[];
    for (final matched in matchedList) {
      final original = findOriginal(matched, packageFormatCredentials);
      if (original == null) continue;
      final index = packageFormatCredentials.indexOf(original);

      presentations.add(
        await buildPresentation(
          credential: candidates[index],
          requestedPaths: requestedPaths,
          uri: uri,
          privateKey: privateKey,
          proofHeaderType: proofHeaderType,
        ),
      );
    }

    vpToken[queryId] = presentations;
  }

  return vpToken;
}
