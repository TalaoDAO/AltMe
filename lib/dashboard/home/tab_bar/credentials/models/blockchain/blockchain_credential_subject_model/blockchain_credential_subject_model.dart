import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blockchain_credential_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
abstract class BlockchainCredentialSubjectModel extends CredentialSubjectModel {
  BlockchainCredentialSubjectModel({
    this.associatedAddress,
    required String super.id,
    required String super.type,
    required super.credentialSubjectType,
    required super.credentialCategory,
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
