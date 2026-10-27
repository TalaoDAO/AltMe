// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:trusted_list/trusted_list.dart';

// A root CA and a leaf it issued, from the trusted_list package tests.
const _root =
    'MIIExDCCAyygAwIBAgIUR1lnX4pFRxlKMfWEpoHDwuhix8IwDQYJKoZIhvcNAQELBQAwaDELMAkGA1UEBhMCRlIxDjAMBgNVBAcMBVBhcmlzMSYwJAYDVQQKDB1UYWxhbyBMb2NhbCBUZXN0IFRydXN0IEFuY2hvcjEhMB8GA1UEAwwYVGFsYW8gTG9jYWwgVGVzdCBSb290IENBMB4XDTI2MDczMDEwMTQ0OFoXDTM2MDcyNzEwMTk0OFowaDELMAkGA1UEBhMCRlIxDjAMBgNVBAcMBVBhcmlzMSYwJAYDVQQKDB1UYWxhbyBMb2NhbCBUZXN0IFRydXN0IEFuY2hvcjEhMB8GA1UEAwwYVGFsYW8gTG9jYWwgVGVzdCBSb290IENBMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEA9Euzy+AjSeX0EJnYv2vbzH5+xwJmixh5wQNvh12Jg2tSLP18AAr2QUadOLwbFKe9VGv32RgBtTe+x5zmVkSysJFSZPyT2wBkJ85h1kIvR3sls/OuwtbHwxBgJr6wIM4tfIZxtp46pC/E6yThq4C9cRcUqgfjM/WHJJ1SOM82uL7bq1YzloJYd1TOn2bnlksSjkC+b7nwBgKRCFoca+SxJrscyInHiaELWJQ1zkMBm8qb2vW9LseG3GAvpOnuQ1WsuIRczsqK5FvHpAyIpcpV/w6lxf/6peCKbVQd64be+sz02Krp45HUbNt5Y8EZzJNiwgkxFaAnmj9FbPyxEwONjWK/H+XaBf2XrIQVsLWkrpOr0OcylbbjLeJUunAPH47svkfTlDe+8uwLATF3dPQET/XNsPiG6y/TsS3oHupF89xshvrx/V0JvdNvnB1Q3GuQHufXHWnjRRjvz6m/zRLoq2CYD2CS6Aowr5MvO8UYEQ6wj6iTVxNNe1WfJYSpMBRlAgMBAAGjZjBkMBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRae0vnaPvexM1c63wCmqUBVlEFxzAfBgNVHSMEGDAWgBRae0vnaPvexM1c63wCmqUBVlEFxzANBgkqhkiG9w0BAQsFAAOCAYEAw08A5DcoOdufB7Z5Z33Nc2foAzWNMtd3uCV8iKLlv+M01dp9JZixNdYs1FQAf9vKd+fRbALkhyIRqypSb56el1+CmmNTlihERtMGs7O3pA7sH/jlQStOD26IN2pIxZ1vJPGVRm6G3tFMjZDuo8k4LOStd4M04GkhPdGHVeeHkO7zZHb5p0BhaE3YitgvHweRXM+AvIIdOXOYr+aEdhOgDUH1NefzA5YPhFvl/0EGmWejUbs73+lev3xg7e3P4rf3KRiiepdyJ2kJLo/yo4gHi1Rw2KOuGl/phmEUp/RrY/Mg69207USE5jbIaYy5VAmp5eTxyvXQcIKwleoRpBQXNKqyqLlZkBrKkq9bbbehGmbDs+XazqVUwP13CZ+dGkn+/8+HVyNn8/ARzShCzCCj2DUhreJypuf61T+TNLBDKMsnXvkdLVRBLV1A46CeZ8HrcHVsaf1mreMAscXLRv7svaahKCOfIu030NC/1TQ0amqysuEAO9Rn8VyJZAI+1TnN';
const _leaf =
    'MIID8zCCAlugAwIBAgIUfIc4vTGzgL8FmJEjUyNrrE12toMwDQYJKoZIhvcNAQELBQAwaDELMAkGA1UEBhMCRlIxDjAMBgNVBAcMBVBhcmlzMSYwJAYDVQQKDB1UYWxhbyBMb2NhbCBUZXN0IFRydXN0IEFuY2hvcjEhMB8GA1UEAwwYVGFsYW8gTG9jYWwgVGVzdCBSb290IENBMB4XDTI2MDkwNDE2NTk1NVoXDTI3MDkwNDE2NTk1NVowgagxCzAJBgNVBAYTAkZSMRwwGgYDVQQKDBNXZWIzIERpZ2l0YWwgV2FsbGV0MRgwFgYDVQRhDA9OVFJGUi05MTAzOTk0MzUxLDAqBgNVBAsMI1dlYjMgRGlnaXRhbCBXYWxsZXQgQ29yZSBFQUEgSXNzdWVyMTMwMQYDVQQDDCpXZWIzIERpZ2l0YWwgV2FsbGV0IFRlc3QgRUFBIElzc3VlciBBY2Nlc3MwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARzhsNSBDimJC5Txlgq3EoiJCdaRHVqYCcForp97mcoSsaGgNe1IEfscHFQywXEA2NUokfoYKOJwcNWx9po2FSVo4GeMIGbMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMB0GA1UdDgQWBBQ0qs4dEjbnTL45EU4xkhtNjiaONzAfBgNVHSMEGDAWgBRae0vnaPvexM1c63wCmqUBVlEFxzA7BgNVHREENDAyhjBodHRwczovL29wZW5pZDR2Yy1odWIuY29tL2lzc3Vlci9jb3JlLWVhYS1pc3N1ZXIwDQYJKoZIhvcNAQELBQADggGBALbRtoEHJzhUI5F9Wk+JS/8bfQd5f5xayMdFbCf9Ymjq/qBGKMRwU3IV8X6jJYSsykRktVZ0japKOzG9iDEACviR1WYqVOSp4uAi7tfr+bgaGL47JjRQXbP9iwISxfvLUkHFhOJsU4v1A9gcMr8LZpQEUICyZRenabiWYJw5vLExXtzgZJMO1JZMxi853dj0rXP+5qcfP6Qpl37e1uM2c8asS2Zr/n5do9GbEmlNQxQYcw4HpAJGsQXmooRNb5lLyZFb9994rV/ECngDkzvDmEfRaMEXzXV93sdr+zHF+PE1GcXQDhMREd58WpQF0bcvVZ3wU8Rj63Qw2m9P5zmvgKkir8Y4mdlpTKe3gZcbALnT+MttBrCUzC+VbOxsAPfAJTc+lRhPBGS/JoGnS4jy+3hzEEQJpXlwRY7VZQRTNxlz7hqAezpFwyExbvfMyA2PqL1Ci3d3Bzcy/qb6Ld2N8tsEDBS4EBUbD2/2/SYF39dMxntXT9+52UgiYis+heaKSw==';

const _mdl = 'org.iso.18013.5.1.mDL';
const _pid = 'eu.europa.ec.eudi.pid.1';

void main() {
  TrustedList listWith(
    TrustedEntityType type,
    List<String> vcTypes, {
    String root = _root,
  }) => TrustedList(
    ecosystem: 'test',
    lastUpdated: '2026-10-23',
    entities: [
      TrustedEntity(
        id: 'https://reader.example',
        type: type,
        name: 'Listed reader',
        rootCertificates: [root],
        vcTypes: vcTypes,
      ),
    ],
  );

  ProximityDocumentRequest document(String docType, {String? signedBy}) =>
      ProximityDocumentRequest(
        docType: docType,
        nameSpaces: const {
          'ns': {'family_name': false},
        },
        readerCertificateChain: signedBy == null
            ? null
            : [Uint8List.fromList(base64Decode(signedBy))],
      );

  group('ProximityReader.of', () {
    test('trusts a reader whose chain a listed verifier root issued', () {
      final reader = ProximityReader.of([
        document(_mdl, signedBy: _leaf),
        document(_pid, signedBy: _leaf),
      ], listWith(TrustedEntityType.verifier, [_mdl, _pid]));

      expect(reader.isTrusted, isTrue);
      expect(reader.name, isNotNull);
    });

    test('does not trust a reader listed for other documents', () {
      final reader = ProximityReader.of([
        document(_mdl, signedBy: _leaf),
        document(_pid, signedBy: _leaf),
      ], listWith(TrustedEntityType.verifier, [_mdl]));

      expect(reader.isTrusted, isFalse);
    });

    test('does not trust a root listed as an issuer', () {
      final reader = ProximityReader.of([
        document(_mdl, signedBy: _leaf),
      ], listWith(TrustedEntityType.issuer, [_mdl]));

      expect(reader.isTrusted, isFalse);
    });

    test('does not trust a chain no listed root issued', () {
      // The root is self-signed: listing the leaf as the root leaves it
      // unrelated.
      final reader = ProximityReader.of([
        document(_mdl, signedBy: _root),
      ], listWith(TrustedEntityType.verifier, [_mdl], root: _leaf));

      expect(reader.isTrusted, isFalse);
    });

    test('does not trust a reader that left a document unsigned', () {
      final reader = ProximityReader.of([
        document(_mdl, signedBy: _leaf),
        document(_pid),
      ], listWith(TrustedEntityType.verifier, [_mdl, _pid]));

      expect(reader.isTrusted, isFalse);
    });

    test('does not trust anyone without a trusted list', () {
      final reader = ProximityReader.of([
        document(_mdl, signedBy: _leaf),
      ], null);

      expect(reader.isTrusted, isFalse);
      expect(reader.name, isNotNull);
    });

    test('knows nothing of a reader that signed nothing', () {
      final reader = ProximityReader.of([
        document(_mdl),
      ], listWith(TrustedEntityType.verifier, [_mdl]));

      expect(reader, const ProximityReader());
    });
  });
}
