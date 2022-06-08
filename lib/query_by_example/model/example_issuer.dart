import 'package:json_annotation/json_annotation.dart';

part 'example_issuer.g.dart';

@JsonSerializable(explicitToJson: true)
class ExampleIssuer {
  ExampleIssuer({required this.issuer});

  factory ExampleIssuer.fromJson(Map<String, dynamic> json) =>
      _$ExampleIssuerFromJson(json);

  final String issuer;

  Map<String, dynamic> toJson() => _$ExampleIssuerToJson(this);
}
