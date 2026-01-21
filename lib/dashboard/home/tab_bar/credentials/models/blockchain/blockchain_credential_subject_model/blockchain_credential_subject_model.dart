import 'package:altme/app/shared/enum/credential_category.dart';
import 'package:altme/app/shared/enum/type/credential_subject_type/credential_subject_type.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blockchain_credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BlockchainCredentialSubjectModel extends CredentialSubjectModel {
  BlockchainCredentialSubjectModel({
    this.associatedAddress,
    required String super.id,
    required String super.type,
    // ignore: type_init_formals
    required CredentialSubjectType super.credentialSubjectType,
    // ignore: type_init_formals
    required CredentialCategory super.credentialCategory,
    super.issuedBy,
    super.offeredBy,
  });

  factory BlockchainCredentialSubjectModel.fromJson(
    Map<String, dynamic> json,
  ) => _$BlockchainCredentialSubjectModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? associatedAddress;

  @override
  Map<String, dynamic> toJson() =>
      _$BlockchainCredentialSubjectModelToJson(this);
}
