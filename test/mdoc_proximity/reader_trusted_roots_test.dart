import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:trusted_list/trusted_list.dart';

void main() {
  final der = 'A' * 70;

  TrustedList trustedList(List<TrustedEntity> entities) =>
      TrustedList(ecosystem: 'test', lastUpdated: '', entities: entities);

  TrustedEntity issuer(String id, List<String> vcTypes, List<String> roots) =>
      TrustedEntity(
        id: id,
        type: TrustedEntityType.issuer,
        vcTypes: vcTypes,
        rootCertificates: roots,
      );

  group('readerTrustedRoots', () {
    test('takes the roots of the issuers of the requested types, as PEM', () {
      final roots = readerTrustedRoots(
        trustedList([
          issuer('https://pid.example', [eudiPidDocType], [der]),
          issuer('https://mdl.example', ['org.iso.18013.5.1.mDL'], ['B']),
        ]),
        [eudiPidDocType],
      );

      expect(roots, [
        [
          '-----BEGIN CERTIFICATE-----',
          'A' * 64,
          'A' * 6,
          '-----END CERTIFICATE-----',
        ].join('\n'),
      ]);
    });

    test('keeps PEM certificates and drops duplicates', () {
      const pem = '-----BEGIN CERTIFICATE-----\nAA\n-----END CERTIFICATE-----';
      final roots = readerTrustedRoots(
        trustedList([
          issuer('https://a.example', [eudiPidDocType], [pem]),
          issuer('https://b.example', [eudiPidDocType], [' $pem ']),
        ]),
        [eudiPidDocType],
      );

      expect(roots, [pem]);
    });

    test('ignores verifiers and an absent trusted list', () {
      expect(
        readerTrustedRoots(
          trustedList([
            TrustedEntity(
              id: 'https://verifier.example',
              type: TrustedEntityType.verifier,
              vcTypes: const [eudiPidDocType],
              rootCertificates: [der],
            ),
          ]),
          [eudiPidDocType],
        ),
        isEmpty,
      );
      expect(readerTrustedRoots(null, [eudiPidDocType]), isEmpty);
    });
  });
}
