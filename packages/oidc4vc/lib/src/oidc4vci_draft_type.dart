import 'package:json_annotation/json_annotation.dart';

enum OIDC4VCIDraftType {
  @JsonValue('11')
  draft11,
  @JsonValue('13')
  draft13,
  @JsonValue('14')
  draft14,
  @JsonValue('15')
  draft15,
}

extension OIDC4VCIDraftTypeX on OIDC4VCIDraftType {
  String get formattedString {
    switch (this) {
      case OIDC4VCIDraftType.draft11:
        return 'Draft 11';
      case OIDC4VCIDraftType.draft13:
        return 'Draft 13';
      case OIDC4VCIDraftType.draft14:
        return 'Draft 14';
      case OIDC4VCIDraftType.draft15:
        return 'Draft 15';
    }
  }

  String get numbering {
    switch (this) {
      case OIDC4VCIDraftType.draft11:
        return '11';
      case OIDC4VCIDraftType.draft13:
        return '13';
      case OIDC4VCIDraftType.draft14:
        return '14';
      case OIDC4VCIDraftType.draft15:
        return '15';
    }
  }

  bool get getNonce {
    /// For OIDC4VCI draft > =14,
    /// the token endpoint does not return a c_nonce.
    switch (this) {
      case OIDC4VCIDraftType.draft11:
      case OIDC4VCIDraftType.draft13:
        return false;
      case OIDC4VCIDraftType.draft14:
      case OIDC4VCIDraftType.draft15:
        return true;
    }
  }
}
