import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over50_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Over50Model extends CredentialSubjectModel {
  Over50Model({super.id, super.type, super.issuedBy, super.offeredBy})
    : super(
        credentialSubjectType: CredentialSubjectType.over50,
        credentialCategory: CredentialCategory.identityCards,
      );

  factory Over50Model.fromJson(Map<String, dynamic> json) =>
      _$Over50ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Over50ModelToJson(this);
}
