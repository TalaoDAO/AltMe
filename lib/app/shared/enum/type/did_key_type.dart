import 'package:altme/l10n/l10n.dart';

enum DidKeyType { secp256k1, p256, ebsiv3, jwkP256 }

extension DidKeyTypeX on DidKeyType {
  String get formattedString {
    switch (this) {
      case DidKeyType.secp256k1:
        return 'did:key secp256k1';
      case DidKeyType.p256:
        return 'did:key P-256';
      case DidKeyType.ebsiv3:
        return 'did:key EBSI-V3';
      case DidKeyType.jwkP256:
        return 'did:jwk P-256';
    }
  }

  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case DidKeyType.secp256k1:
        return l10n.keyDecentralizedIDSecp256k1;
      case DidKeyType.p256:
        return l10n.keyDecentralizedIDP256;
      case DidKeyType.ebsiv3:
        return l10n.ebsiV3DecentralizedId;
      case DidKeyType.jwkP256:
        return l10n.jwkDecentralizedIDP256;
    }
  }
}
