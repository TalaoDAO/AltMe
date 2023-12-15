import 'package:json_annotation/json_annotation.dart';

enum OIDC4VCIDraftType {
  @JsonValue('8')
  draft8,
  @JsonValue('11')
  draft11,
  @JsonValue('12')
  draft12,
}

extension OIDC4VCIDraftTypeX on OIDC4VCIDraftType {
  String get formattedString {
    switch (this) {
      case OIDC4VCIDraftType.draft8:
        return 'Draft 8';
      case OIDC4VCIDraftType.draft11:
        return 'Draft 11';
      case OIDC4VCIDraftType.draft12:
        return 'Draft 12';
    }
  }
}
