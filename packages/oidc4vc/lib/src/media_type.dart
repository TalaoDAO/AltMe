enum MediaType {
  proofOfOwnership,
  basic,
  walletAttestation,
}

extension MediaTypeX on MediaType {
  String get typ {
    switch (this) {
      case MediaType.proofOfOwnership:
        return 'openid4vci-proof+jwt';
      case MediaType.basic:
        return 'jwt';
      case MediaType.walletAttestation:
        return 'wiar+jwt';
    }
  }
}
