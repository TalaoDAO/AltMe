enum KycVcType { verifiableId, over13, over15, over18, ageRange }

extension KycVcTypeX on KycVcType {
  String get value {
    switch (this) {
      case KycVcType.verifiableId:
        return 'VerifiableId';
      case KycVcType.over13:
        return 'Over13';
      case KycVcType.over15:
        return 'Over15';
      case KycVcType.over18:
        return 'Over18';
      case KycVcType.ageRange:
        return 'AgeRange';
    }
  }
}
