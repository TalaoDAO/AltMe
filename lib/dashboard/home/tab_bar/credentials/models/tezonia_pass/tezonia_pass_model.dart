import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/offers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezonia_pass_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TezoniaPassModel extends CredentialSubjectModel {
  TezoniaPassModel({
    this.expires,
    this.offers,
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.tezoniaPass,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory TezoniaPassModel.fromJson(Map<String, dynamic> json) =>
      _$TezoniaPassModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? expires;
  final Offers? offers;

  @override
  Map<String, dynamic> toJson() => _$TezoniaPassModelToJson(this);
}
