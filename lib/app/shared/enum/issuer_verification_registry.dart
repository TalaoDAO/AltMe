import 'package:json_annotation/json_annotation.dart';

enum IssuerVerificationRegistry {
  @JsonValue('polygon')
  PolygonMainnet,
  @JsonValue('polygonTestnet')
  PolygonTestnet,
  @JsonValue('ebsi')
  EBSI,
}
