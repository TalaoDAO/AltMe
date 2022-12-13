import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pcds_agent_certificate_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PcdsAgentCertificateModel extends CredentialSubjectModel {
  PcdsAgentCertificateModel({
    String? id,
    String? type,
    Author? issuedBy,
    this.identifier,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.pcdsAgentCertificate,
          credentialCategory: CredentialCategory.myProfessionalCards,
        );

  factory PcdsAgentCertificateModel.fromJson(Map<String, dynamic> json) =>
      _$PcdsAgentCertificateModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? identifier;

  @override
  Map<String, dynamic> toJson() => _$PcdsAgentCertificateModelToJson(this);
}
