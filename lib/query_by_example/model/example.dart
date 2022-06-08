import 'package:altme/query_by_example/model/example_issuer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'example.g.dart';

@JsonSerializable(explicitToJson: true)
class Example {
  Example({required this.type, required this.trustedIssuer});

  factory Example.fromJson(Map<String, dynamic> json) =>
      _$ExampleFromJson(json);

  final String? type;
  final List<ExampleIssuer>? trustedIssuer;

  Map<String, dynamic> toJson() => _$ExampleToJson(this);
}
