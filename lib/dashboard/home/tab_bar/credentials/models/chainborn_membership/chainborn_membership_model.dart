import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chainborn_membership_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChainbornMembershipModel extends CredentialSubjectModel {
  ChainbornMembershipModel({
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.chainbornMembership,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory ChainbornMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$ChainbornMembershipModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChainbornMembershipModelToJson(this);
}
