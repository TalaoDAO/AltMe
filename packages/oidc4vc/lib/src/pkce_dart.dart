import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// A pair of ([codeVerifier], [codeChallenge]) that can be used with PKCE
/// (Proof Key for Code Exchange).
class PkcePair {
  const PkcePair(this.codeVerifier, this.codeChallenge);

  /// Generates a [PkcePair].
  ///
  /// [length] is the length used to generate the [codeVerifier]. It must be
  /// between 32 and 96, inclusive, which corresponds to a [codeVerifier] of
  /// length between 43 and 128, inclusive. The spec recommends a length of 32.
  factory PkcePair.generate({int length = 32}) {
    if (length < 32 || length > 96) {
      throw ArgumentError.value(
        length,
        'length',
        'The length must be between 32 and 96, inclusive.',
      );
    }

    final random = Random.secure();
    final verifier =
        base64UrlEncode(List.generate(length, (_) => random.nextInt(256)))
            .split('=')[0];
    final challenge =
        base64UrlEncode(sha256.convert(ascii.encode(verifier)).bytes)
            .split('=')[0];

    return PkcePair(verifier, challenge);
  }

  /// The code verifier.
  final String codeVerifier;

  /// The code challenge, computed as base64Url(sha256([codeVerifier])) with
  /// padding removed as per the spec.
  final String codeChallenge;
}
