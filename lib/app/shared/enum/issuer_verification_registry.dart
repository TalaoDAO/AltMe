import 'package:json_annotation/json_annotation.dart';

enum IssuerVerificationRegistry {
  @JsonValue('none')
  None,
  @JsonValue('talao')
  Talao,
  @JsonValue('ebsi')
  EBSI,
  @JsonValue('compellio')
  Compellio,
}
