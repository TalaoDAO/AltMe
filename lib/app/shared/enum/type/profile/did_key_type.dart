import 'package:altme/l10n/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

enum DidKeyType {
  @JsonValue('did:key:eddsa')
  edDSA,
  @JsonValue('did:key:secp256k1')
  secp256k1,
  @JsonValue('did:key:p-256')
  p256,
  @JsonValue('did:key:ebsi')
  ebsiv3,
  ebsiv4,
  @JsonValue('did:jwk:p-256')
  jwkP256,
  @JsonValue(
    'urn:ietf:params:oauth:client-assertion-type:jwt-client-attestation',
  )
  jwtClientAttestation,
}

extension DidKeyTypeX on DidKeyType {
  String get formattedString {
    switch (this) {
      case DidKeyType.edDSA:
        return 'did:key edDSA';
      case DidKeyType.secp256k1:
        return 'did:key secp256k1';
      case DidKeyType.p256:
        return 'did:key P-256';
      case DidKeyType.ebsiv3:
        return 'did:key EBSI-V3';
      case DidKeyType.ebsiv4:
        return 'did:key EBSI-V4';
      case DidKeyType.jwkP256:
        return 'did:jwk P-256';
      case DidKeyType.jwtClientAttestation:
        return '';
    }
  }

  String get didString {
    switch (this) {
      case DidKeyType.edDSA:
        return 'did:key edDSA';
      case DidKeyType.secp256k1:
        return 'did:key secp256k1';
      case DidKeyType.p256:
        return 'did:key P-256';
      case DidKeyType.ebsiv3:
      case DidKeyType.ebsiv4:
        return 'did:key EBSI P-256';
      case DidKeyType.jwkP256:
        return 'did:jwk P-256';
      case DidKeyType.jwtClientAttestation:
        return '';
    }
  }

  String get subjectSyntaxTypesSupported {
    switch (this) {
      case DidKeyType.edDSA:
        return 'did:key';
      case DidKeyType.secp256k1:
        return 'did:key';
      case DidKeyType.p256:
        return 'did:key';
      case DidKeyType.ebsiv3:
      case DidKeyType.ebsiv4:
        // old rule was to strict
        // return 'did:key:jwk_jcs-pub';
        return 'did:key';
      case DidKeyType.jwkP256:
        return 'did:jwk';
      case DidKeyType.jwtClientAttestation:
        return '';
    }
  }

  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case DidKeyType.edDSA:
        return l10n.keyDecentralizedIdEdSA;
      case DidKeyType.secp256k1:
        return l10n.keyDecentralizedIDSecp256k1;
      case DidKeyType.p256:
        return l10n.keyDecentralizedIDP256;
      case DidKeyType.ebsiv3:
        return l10n.ebsiV3DecentralizedId;
      case DidKeyType.ebsiv4:
        return l10n.ebsiV4DecentralizedId;
      case DidKeyType.jwkP256:
        return l10n.jwkDecentralizedIDP256;
      case DidKeyType.jwtClientAttestation:
        return '';
    }
  }

  bool get supportCryptoCredential {
    switch (this) {
      case DidKeyType.secp256k1:
      case DidKeyType.p256:
      case DidKeyType.jwkP256:
      case DidKeyType.jwtClientAttestation:
      case DidKeyType.edDSA:
        return true;
      case DidKeyType.ebsiv3:
      case DidKeyType.ebsiv4:
        return false;
    }
  }
}
