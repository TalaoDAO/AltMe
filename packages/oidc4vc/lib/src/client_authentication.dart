import 'package:json_annotation/json_annotation.dart';

enum ClientAuthentication {
  none,
  @JsonValue('client_secret_basic')
  clientSecretBasic,
  // @JsonValue('client_secret_jwt')
  // clientSecretJwt,
  @JsonValue('client_secret_post')
  clientSecretPost,
}

extension ClientAuthenticationX on ClientAuthentication {
  String get value {
    switch (this) {
      case ClientAuthentication.none:
        return 'none';
      case ClientAuthentication.clientSecretBasic:
        return 'client_secret_basic';
      case ClientAuthentication.clientSecretPost:
        return 'client_secret_post';
    }
  }
}
