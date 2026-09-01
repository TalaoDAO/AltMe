import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:dcql/dcql.dart';
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

String buildPresentation({
  required CredentialModel credential,
  required List<List<dynamic>> requestedPaths, // from DcqlClaim.path
}) {
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

  // final presented = await SdJwtHandlerV1().present(
  //   sdJwt: SdJwt.parse(credential.jwt!),
  //   disclosuresToKeep: disclosuresToKeep,
  //   // presentWithKbJwtInput: PresentWithKbJwtInput(audience, signer, holderPublicKey),
  // );

  return newJwt;
}

// --- Build the vp_token itself ---
Map<String, List<String>> buildVpToken(
  DcqlQueryResult result,
  List<SdJwtDigitalCredential> packageFormatCredentials,
  List<CredentialModel> candidates, // your wallet-side objects, same order
) {
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
        buildPresentation(
          credential: candidates[index],
          requestedPaths: requestedPaths,
        ),
      );
    }

    vpToken[queryId] = presentations;
  }

  return vpToken;
}
