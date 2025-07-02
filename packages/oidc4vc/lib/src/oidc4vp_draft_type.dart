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
  @JsonValue('28')
  draft28,
  @JsonValue('29')
  draft29,
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
        return 'Draft 23 (Partial)';
      case OIDC4VPDraftType.draft28:
        return 'Draft 28 (Partial)';
      case OIDC4VPDraftType.draft29:
        return 'Draft 29 (Partial)';
    }
  }

  String get numbering {
    switch (this) {
      case OIDC4VPDraftType.draft10:
        return '10';
      case OIDC4VPDraftType.draft13:
        return '13';
      case OIDC4VPDraftType.draft18:
        return '18';
      case OIDC4VPDraftType.draft20:
        return '20';
      case OIDC4VPDraftType.draft21:
        return '21';
      case OIDC4VPDraftType.draft22:
        return '22';
      case OIDC4VPDraftType.draft23:
        return '23';
      case OIDC4VPDraftType.draft28:
        return '28';
      case OIDC4VPDraftType.draft29:
        return '29';
    }
  }

  bool get draft22AndAbove {
    return int.parse(numbering) > 21;
  }
}
