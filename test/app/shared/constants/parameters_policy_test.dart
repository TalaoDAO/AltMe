import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oidc4vc/oidc4vc.dart';

void main() {
  group('Parameters.policyFor', () {
    test('maps the EUDI Wallet profile to haip', () {
      final policy = Parameters.policyFor(ProfileType.EUDIW);

      expect(policy.id, 'haip');
      expect(policy.mode, PolicyMode.lenient);
      expect(policy.hasWalletAttestation, isTrue);
    });

    test('maps every other profile to core lenient', () {
      for (final type in ProfileType.values.where(
        (type) => type != ProfileType.EUDIW,
      )) {
        final policy = Parameters.policyFor(type);

        expect(policy.id, 'core', reason: type.name);
        expect(policy.mode, PolicyMode.lenient, reason: type.name);
      }
    });

    test('gives the default profile no wallet attestation', () {
      expect(
        Parameters.policyFor(ProfileType.defaultOne).hasWalletAttestation,
        isFalse,
      );
      expect(
        Parameters.policyFor(ProfileType.custom).hasWalletAttestation,
        isTrue,
      );
    });
  });
}
