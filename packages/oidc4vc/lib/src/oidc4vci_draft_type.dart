import 'package:json_annotation/json_annotation.dart';

enum OIDC4VCIDraftType {
  @JsonValue('11')
  draft11,
  @JsonValue('13')
  draft13,
}

extension OIDC4VCIDraftTypeX on OIDC4VCIDraftType {
  String get formattedString {
    switch (this) {
      case OIDC4VCIDraftType.draft11:
        return 'Draft 11';
      case OIDC4VCIDraftType.draft13:
        return 'Draft 13';
    }
  }

  String get numbering {
    switch (this) {
      case OIDC4VCIDraftType.draft11:
        return '11';
      case OIDC4VCIDraftType.draft13:
        return '13';
    }
  }
}
