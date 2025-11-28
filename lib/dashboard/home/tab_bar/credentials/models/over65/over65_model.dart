import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over65_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Over65Model extends CredentialSubjectModel {
  Over65Model({super.id, super.type, super.issuedBy, super.offeredBy})
    : super(
        credentialSubjectType: CredentialSubjectType.over65,
        credentialCategory: CredentialCategory.identityCards,
      );

  factory Over65Model.fromJson(Map<String, dynamic> json) =>
      _$Over65ModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Over65ModelToJson(this);
}
