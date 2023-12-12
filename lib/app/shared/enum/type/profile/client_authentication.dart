import 'package:json_annotation/json_annotation.dart';

enum ClientAuthentication {
  none,
  @JsonValue('client_secret_basic')
  clientSecretBasic,
  @JsonValue('client_secret_jwt')
  clientSecretJwt,
}
