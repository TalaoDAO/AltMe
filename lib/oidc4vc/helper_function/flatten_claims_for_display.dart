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
