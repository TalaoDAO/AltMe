import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chainborn_membership_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChainbornMembershipModel extends CredentialSubjectModel {
  ChainbornMembershipModel({
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.chainbornMembership,
          credentialCategory: CredentialCategory.gamingCards,
        );

  factory ChainbornMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$ChainbornMembershipModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChainbornMembershipModelToJson(this);
}
