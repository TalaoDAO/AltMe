import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_query.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialQuery {
  CredentialQuery(this.reason);

  factory CredentialQuery.fromJson(Map<String, dynamic> json) =>
      _$CredentialQueryFromJson(json);

  @JsonKey(defaultValue: <Translation>[])
  final List<Translation> reason;

  Map<String, dynamic> toJson() => _$CredentialQueryToJson(this);
}
