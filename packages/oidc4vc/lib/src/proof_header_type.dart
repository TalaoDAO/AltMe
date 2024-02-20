enum ProofHeaderType {
  kid,
  jwk,
}

extension ProofHeaderTypeX on ProofHeaderType {
  String get formattedString {
    switch (this) {
      case ProofHeaderType.kid:
        return 'kid';
      case ProofHeaderType.jwk:
        return 'jwk';
    }
  }
}
