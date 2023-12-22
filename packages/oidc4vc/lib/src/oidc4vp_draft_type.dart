import 'package:json_annotation/json_annotation.dart';

enum OIDC4VPDraftType {
  @JsonValue('10')
  draft10,
  @JsonValue('13')
  draft13,
  @JsonValue('18')
  draft18,
}

extension OIDC4VPDraftTypeX on OIDC4VPDraftType {
  String get formattedString {
    switch (this) {
      case OIDC4VPDraftType.draft10:
        return 'Draft 10';
      case OIDC4VPDraftType.draft13:
        return 'Draft 13';
      case OIDC4VPDraftType.draft18:
        return 'Draft 18';
    }
  }
}
