import 'package:json_annotation/json_annotation.dart';

enum SubjectSyntax {
  @JsonValue('urn:ietf:params:oauth:jwk-thumbprint')
  jwkThumbprint,

  did,
}
