import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const endpoint = 'https://issuer.example/deferred_credential';

  group('isDeferredCredentialResponse', () {
    test('is true for a transaction_id the issuer can be asked about', () {
      expect(
        isDeferredCredentialResponse({
          'transaction_id': 'tx-1',
          'interval': 30,
        }, endpoint),
        isTrue,
      );
    });

    test('is true for the acceptance_token of drafts before 13', () {
      expect(
        isDeferredCredentialResponse({'acceptance_token': 'at-1'}, endpoint),
        isTrue,
      );
    });

    test('is false for an issued credential', () {
      expect(
        isDeferredCredentialResponse({'credential': 'vc'}, endpoint),
        isFalse,
      );
    });

    test('is false without a deferred credential endpoint', () {
      expect(
        isDeferredCredentialResponse({'transaction_id': 'tx-1'}, null),
        isFalse,
      );
    });
  });
}
