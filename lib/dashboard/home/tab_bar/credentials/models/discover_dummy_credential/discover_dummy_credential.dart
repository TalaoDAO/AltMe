import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

part 'discover_dummy_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class DiscoverDummyCredential extends Equatable {
  const DiscoverDummyCredential({
    required this.credentialSubjectType,
    this.vcFormatType = VCFormatType.ldpVc,
    this.link,
    this.image,
    this.websiteLink,
    this.whyGetThisCard,
    this.expirationDateDetails,
    this.howToGetIt,
    this.longDescription,
    this.display,
    this.whyGetThisCardExtern,
    this.expirationDateDetailsExtern,
    this.howToGetItExtern,
    this.longDescriptionExtern,
    this.websiteLinkExtern,
  });

  factory DiscoverDummyCredential.fromJson(Map<String, dynamic> json) =>
      _$DiscoverDummyCredentialFromJson(json);

  final String? link;
  final String? image;
  final CredentialSubjectType credentialSubjectType;
  final String? websiteLink;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? whyGetThisCard;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? expirationDateDetails;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? howToGetIt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? longDescription;
  final Display? display;
  final String? whyGetThisCardExtern;
  final String? expirationDateDetailsExtern;
  final String? howToGetItExtern;
  final String? longDescriptionExtern;
  final String? websiteLinkExtern;
  final VCFormatType vcFormatType;

  Map<String, dynamic> toJson() => _$DiscoverDummyCredentialToJson(this);

  @override
  List<Object?> get props => [
    link,
    image,
    credentialSubjectType,
    websiteLink,
    whyGetThisCard,
    expirationDateDetails,
    howToGetIt,
    longDescription,
    display,
    whyGetThisCardExtern,
    expirationDateDetailsExtern,
    howToGetItExtern,
    longDescriptionExtern,
    websiteLinkExtern,
    vcFormatType,
  ];
}
