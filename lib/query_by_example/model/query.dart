import 'package:altme/query_by_example/model/credential_query.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query.g.dart';

@JsonSerializable(explicitToJson: true)
class Query {
  Query({required this.type, required this.credentialQuery});

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: <CredentialQuery>[])
  final List<CredentialQuery> credentialQuery;

  Map<String, dynamic> toJson() => _$QueryToJson(this);
}
