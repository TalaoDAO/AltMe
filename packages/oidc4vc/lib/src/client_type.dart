import 'package:json_annotation/json_annotation.dart';

enum ClientType {
  @JsonValue('urn:ietf:params:oauth:jwk-thumbprint')
  jwkThumbprint,

  did,

  confidential,
}

extension ClientTypeX on ClientType {
  String get getTitle {
    switch (this) {
      case ClientType.jwkThumbprint:
        return 'P-256 JWK Thumbprint';
      case ClientType.did:
        return 'DID';
      case ClientType.confidential:
        return 'Confidential Client';
    }
  }
}
