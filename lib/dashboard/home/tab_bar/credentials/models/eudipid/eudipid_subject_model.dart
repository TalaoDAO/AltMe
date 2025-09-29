import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eudipid_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EudipidSubjectModel extends CredentialSubjectModel {
  EudipidSubjectModel({super.id, super.type, super.issuedBy})
    : super(
        credentialSubjectType: CredentialSubjectType.eudiPid,
        credentialCategory: CredentialCategory.identityCards,
      );

  factory EudipidSubjectModel.fromJson(Map<String, dynamic> json) =>
      _$EudipidSubjectModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EudipidSubjectModelToJson(this);
}
