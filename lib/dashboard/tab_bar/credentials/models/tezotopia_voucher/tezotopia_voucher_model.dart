import 'package:altme/app/app.dart';
import 'package:altme/dashboard/tab_bar/credentials/models/author/author.dart';
import 'package:altme/dashboard/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezotopia_voucher_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TezotopiaVoucherModel extends CredentialSubjectModel {
  TezotopiaVoucherModel({
    String? id,
    String? type,
    Author? issuedBy,
    this.identifier,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.tezVoucher,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory TezotopiaVoucherModel.fromJson(Map<String, dynamic> json) =>
      _$TezotopiaVoucherModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? identifier;

  @override
  Map<String, dynamic> toJson() => _$TezotopiaVoucherModelToJson(this);
}
