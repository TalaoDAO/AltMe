import 'package:altme/oidc4vc/helper_function/authorization_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const secret = 'authorization-uri-secret';
  // A PKCE S256 code challenge: 43 base64url characters.
  const challenge = 'acr1iOw__abV_fWaM_J-27DWoXBHShfjm4F4iZaHYBU';

  group('AuthorizationState', () {
    test('gives back the challenge it carries', () {
      final state = AuthorizationState.encrypt(challenge, secret: secret);

      expect(AuthorizationState.decrypt(state, secret: secret), challenge);
    });

    test('is at most 128 bytes', () {
      final state = AuthorizationState.encrypt(challenge, secret: secret);

      expect(state.length, lessThanOrEqualTo(128));
    });

    test('does not show the challenge', () {
      final state = AuthorizationState.encrypt(challenge, secret: secret);

      expect(state, isNot(contains(challenge)));
    });

    test('differs for each request', () {
      expect(
        AuthorizationState.encrypt(challenge, secret: secret),
        isNot(AuthorizationState.encrypt(challenge, secret: secret)),
      );
    });

    test('refuses an altered state', () {
      final state = AuthorizationState.encrypt(challenge, secret: secret);
      // In the middle, where every bit of a character is data (the last one
      // may carry padding bits only).
      const at = 30;
      final altered =
          state.substring(0, at) +
          (state[at] == 'A' ? 'B' : 'A') +
          state.substring(at + 1);

      expect(
        () => AuthorizationState.decrypt(altered, secret: secret),
        throwsArgumentError,
      );
    });

    test('refuses a state made with another secret', () {
      final state = AuthorizationState.encrypt(challenge, secret: 'other');

      expect(
        () => AuthorizationState.decrypt(state, secret: secret),
        throwsArgumentError,
      );
    });

    test('refuses something that is not a state', () {
      expect(
        () => AuthorizationState.decrypt('not a state!', secret: secret),
        throwsArgumentError,
      );
      expect(
        () => AuthorizationState.decrypt('c2hvcnQ', secret: secret),
        throwsArgumentError,
      );
    });
  });
}
