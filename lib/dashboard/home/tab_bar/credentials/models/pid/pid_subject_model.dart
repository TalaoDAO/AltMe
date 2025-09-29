import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pid_subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PidSubjectModel extends CredentialSubjectModel {
  PidSubjectModel({super.id, super.type, super.issuedBy})
    : super(
        credentialSubjectType: CredentialSubjectType.pid,
        credentialCategory: CredentialCategory.identityCards,
      );

  factory PidSubjectModel.fromJson(Map<String, dynamic> json) =>
      _$PidSubjectModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PidSubjectModelToJson(this);
}
