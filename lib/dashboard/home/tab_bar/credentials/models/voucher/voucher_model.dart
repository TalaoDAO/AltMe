import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/voucher/offer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'voucher_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VoucherModel extends CredentialSubjectModel {
  VoucherModel({
    super.id,
    super.type,
    super.issuedBy,
    this.identifier,
    this.offer,
  }) : super(
          credentialSubjectType: CredentialSubjectType.voucher,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory VoucherModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? identifier;
  final Offer? offer;

  @override
  Map<String, dynamic> toJson() => _$VoucherModelToJson(this);
}
