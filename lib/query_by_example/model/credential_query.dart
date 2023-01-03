import 'package:altme/query_by_example/model/example.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_query.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialQuery {
  CredentialQuery({
    this.reason,
    this.example,
    this.required,
  });

  factory CredentialQuery.fromJson(Map<String, dynamic> json) =>
      _$CredentialQueryFromJson(json);

  final Example? example;
  final String? reason;
  final bool? required;

  Map<String, dynamic> toJson() => _$CredentialQueryToJson(this);
}
