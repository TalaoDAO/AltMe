import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/home/tab_bar/credentials/models/voucher/offer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'voucher_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VoucherModel extends CredentialSubjectModel {
  VoucherModel({
    String? id,
    String? type,
    Author? issuedBy,
    this.identifier,
    this.offer,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
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
