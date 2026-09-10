import 'dart:convert';

import 'package:altme/app/shared/helper_functions/get_display.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';

const _excludedTopLevelClaimKeys = {
  'id',
  'type',
  '@context',
  'proof',
  'issuer',
  'credentialSchema',
  'credentialStatus',
  'issuanceDate',
  'issuedAt',
  'expirationDate',
  'validFrom',
  'validUntil',
};

/// Flattens a (Verifiable Credential-shaped) claims map into the exact
/// name/value pairs to show on a confirmation screen.
///
/// Prefers the `credentialSubject` object when present, since that is where
/// the actual disclosed attributes live in a VC; otherwise falls back to the
/// top-level map, minus VC housekeeping fields.
List<ClaimEntry> flattenClaimsForDisplay(Map<String, dynamic> data) {
  final subject = data['credentialSubject'];
  if (subject is Map<String, dynamic>) {
    return _flatten(subject, excludeTopLevel: {'id', 'type'});
  }
  return _flatten(data, excludeTopLevel: _excludedTopLevelClaimKeys);
}

/// Flattens the claim name/value pairs of one or more credentials about to
/// be shared with a verifier. Claim labels are prefixed with the
/// credential's type when more than one credential is presented, to avoid
/// ambiguity.
List<ClaimEntry> flattenCredentialsForDisplay(
  List<CredentialModel> credentials,
) {
  final multiple = credentials.length > 1;
  final entries = <ClaimEntry>[];

  for (final credentialModel in credentials) {
    final type = credentialModel.credentialPreview.type;
    final prefix = multiple && type.isNotEmpty ? type.last : '';

    for (final claim in flattenClaimsForDisplay(credentialModel.data)) {
      entries.add(
        ClaimEntry(
          label: prefix.isEmpty ? claim.label : '$prefix: ${claim.label}',
          value: claim.value,
        ),
      );
    }
  }

  return entries;
}

/// Builds translated claim name/value pairs for a single OIDC4VCI-issued
/// credential, using its `credentialSupported` metadata (`credential_metadata
/// .claims` / `claims`, each entry with a `path` and localized `display`).
/// Falls back to raw-key flattening when no such metadata is available.
List<ClaimEntry> buildTranslatedClaims({
  required CredentialModel credentialModel,
  required String languageCode,
}) {
  final credentialSupported = credentialModel.credentialSupported;
  final claimsList =
      credentialSupported?['credential_metadata']?['claims'] ??
      credentialSupported?['claims'];

  if (claimsList is! List || claimsList.isEmpty) {
    return flattenClaimsForDisplay(credentialModel.data);
  }

  final entries = <ClaimEntry>[];
  for (final claim in claimsList) {
    if (claim is! Map<String, dynamic>) continue;
    final path = claim['path'];
    if (path is! List) continue;

    final value = _valueAtPath(credentialModel.data, path);
    if (value == null) continue;

    final display = getDisplay(claim, languageCode);
    final label = (display is Map && display['name'] != null)
        ? display['name'].toString()
        : path.map((s) => s == null ? '*' : s.toString()).join(' > ');

    entries.add(
      ClaimEntry(
        label: label,
        value: value is Map || value is List
            ? jsonEncode(value)
            : value.toString(),
      ),
    );
  }

  return entries.isEmpty
      ? flattenClaimsForDisplay(credentialModel.data)
      : entries;
}

dynamic _valueAtPath(dynamic data, List<dynamic> path) {
  dynamic current = data;
  for (final segment in path) {
    if (current is Map) {
      current = current[segment];
    } else if (current is List && segment is int) {
      current = (segment >= 0 && segment < current.length)
          ? current[segment]
          : null;
    } else {
      return null;
    }
    if (current == null) return null;
  }
  return current;
}

List<ClaimEntry> _flatten(
  dynamic data, {
  String prefix = '',
  Set<String> excludeTopLevel = const {},
}) {
  final entries = <ClaimEntry>[];

  if (data is Map) {
    data.forEach((key, value) {
      final keyStr = key.toString();
      if (prefix.isEmpty && excludeTopLevel.contains(keyStr)) return;

      final label = prefix.isEmpty ? keyStr : '$prefix.$keyStr';
      if (value is Map || value is List) {
        entries.addAll(_flatten(value, prefix: label));
      } else if (value != null) {
        entries.add(ClaimEntry(label: label, value: value.toString()));
      }
    });
  } else if (data is List) {
    for (var i = 0; i < data.length; i++) {
      entries.addAll(_flatten(data[i], prefix: '$prefix[$i]'));
    }
  }

  return entries;
}
