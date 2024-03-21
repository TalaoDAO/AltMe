enum MediaType {
  proofOfOwnership,
  basic,
  walletAttestation,
  selectiveDisclosure,
}

extension MediaTypeX on MediaType {
  String get typ {
    switch (this) {
      case MediaType.proofOfOwnership:
        return 'openid4vci-proof+jwt';
      case MediaType.basic:
        return 'JWT';
      case MediaType.walletAttestation:
        return 'wiar+jwt';
      case MediaType.selectiveDisclosure:
        return 'kb+jwt';
    }
  }
}
