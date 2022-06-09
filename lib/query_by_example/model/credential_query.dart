import 'package:altme/app/app.dart';
import 'package:altme/query_by_example/model/example.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_query.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialQuery {
  CredentialQuery(this.reason, this.example);

  factory CredentialQuery.fromJson(Map<String, dynamic> json) =>
      _$CredentialQueryFromJson(json);

  @JsonKey(defaultValue: <Translation>[])
  final List<Translation>? reason;
  final Example? example;

  Map<String, dynamic> toJson() => _$CredentialQueryToJson(this);
}
