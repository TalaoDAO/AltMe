import 'dart:convert';

import 'package:mdoc/mdoc.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';
import 'package:uuid/uuid.dart';

/// A new platform key alias for one SD-JWT copy of a batch issuance.
String newSdJwtKeyAlias() => 'sdjwt_${const Uuid().v4()}';

/// Whether [keyId] names a key this wallet holds in the platform key store
/// (an mso_mdoc key, or the key of an SD-JWT batch copy), rather than a key
/// of a Wallet Key Attestation key store.
bool isPlatformKeyAlias(String keyId) =>
    keyId.startsWith('mdoc_') || keyId.startsWith('sdjwt_');

/// Which of the platform keys [aliases] [credential] is bound to, or `null`
/// when it is bound to none of them.
///
/// [credential] is one entry of a Credential Response's `credentials`, in
/// [format]: an SD-JWT names its key in `cnf.jwk`, an mso_mdoc in its MSO's
/// `deviceKeyInfo`. OpenID4VCI 1.0 §8.3 defines no order between the
/// credentials of a response and the proofs of the request, so the key is
/// read from the credential, never from its position.
Future<String?> boundKeyAlias({
  required String credential,
  required String format,
  required Iterable<String> aliases,
  PlatformP256Keys platformKeys = const PlatformP256Keys(),
}) async {
  final bool Function(PlatformP256Key key) isBound;
  if (format == 'mso_mdoc') {
    final IssuerSigned mdoc;
    try {
      mdoc = IssuerSigned.fromBase64Url(credential);
    } on FormatException {
      return null;
    }
    isBound = (key) => mdoc.isBoundTo(key.publicKey);
  } else {
    final jwk = _cnfJwk(credential);
    if (jwk == null) return null;
    isBound = (key) {
      final publicJwk = key.publicJwk;
      return jwk['x'] == publicJwk['x'] && jwk['y'] == publicJwk['y'];
    };
  }

  for (final alias in aliases) {
    final key = await platformKeys.find(alias);
    if (key != null && isBound(key)) return alias;
  }
  return null;
}

/// The `cnf.jwk` of the issuer-signed JWT of an SD-JWT, or `null` when it
/// has none or cannot be read.
Map<String, dynamic>? _cnfJwk(String sdJwt) {
  final parts = sdJwt.split('~').first.split('.');
  if (parts.length != 3) return null;
  try {
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    if (payload is! Map<String, dynamic>) return null;
    final cnf = payload['cnf'];
    final jwk = cnf is Map<String, dynamic> ? cnf['jwk'] : null;
    return jwk is Map<String, dynamic> ? jwk : null;
  } on FormatException {
    return null;
  }
}
