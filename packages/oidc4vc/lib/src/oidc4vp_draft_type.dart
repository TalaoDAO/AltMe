import 'package:json_annotation/json_annotation.dart';

enum OIDC4VPDraftType {
  @JsonValue('10')
  draft10,
  @JsonValue('13')
  draft13,
  @JsonValue('18')
  draft18,
  @JsonValue('20')
  draft20,
  @JsonValue('21')
  draft21,
  @JsonValue('22')
  draft22,
  @JsonValue('23')
  draft23,
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
      case OIDC4VPDraftType.draft20:
        return 'Draft 20';
      case OIDC4VPDraftType.draft21:
        return 'Draft 21';
      case OIDC4VPDraftType.draft22:
        return 'Draft 22 (Partial)';
      case OIDC4VPDraftType.draft23:
        return 'Draft 23';
    }
  }
}
