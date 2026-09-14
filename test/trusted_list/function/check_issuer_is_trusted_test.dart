// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:altme/trusted_list/function/check_issuer_is_trusted.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/model/trusted_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Talao root CA, used both as the trusted list's `rootCertificates` entry
  // and as the CA that issued the leaf certificate below.
  const rootCertificate =
      'MIIExDCCAyygAwIBAgIUR1lnX4pFRxlKMfWEpoHDwuhix8IwDQYJKoZIhvcNAQELBQAwaDELMAkGA1UEBhMCRlIxDjAMBgNVBAcMBVBhcmlzMSYwJAYDVQQKDB1UYWxhbyBMb2NhbCBUZXN0IFRydXN0IEFuY2hvcjEhMB8GA1UEAwwYVGFsYW8gTG9jYWwgVGVzdCBSb290IENBMB4XDTI2MDczMDEwMTQ0OFoXDTM2MDcyNzEwMTk0OFowaDELMAkGA1UEBhMCRlIxDjAMBgNVBAcMBVBhcmlzMSYwJAYDVQQKDB1UYWxhbyBMb2NhbCBUZXN0IFRydXN0IEFuY2hvcjEhMB8GA1UEAwwYVGFsYW8gTG9jYWwgVGVzdCBSb290IENBMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEA9Euzy+AjSeX0EJnYv2vbzH5+xwJmixh5wQNvh12Jg2tSLP18AAr2QUadOLwbFKe9VGv32RgBtTe+x5zmVkSysJFSZPyT2wBkJ85h1kIvR3sls/OuwtbHwxBgJr6wIM4tfIZxtp46pC/E6yThq4C9cRcUqgfjM/WHJJ1SOM82uL7bq1YzloJYd1TOn2bnlksSjkC+b7nwBgKRCFoca+SxJrscyInHiaELWJQ1zkMBm8qb2vW9LseG3GAvpOnuQ1WsuIRczsqK5FvHpAyIpcpV/w6lxf/6peCKbVQd64be+sz02Krp45HUbNt5Y8EZzJNiwgkxFaAnmj9FbPyxEwONjWK/H+XaBf2XrIQVsLWkrpOr0OcylbbjLeJUunAPH47svkfTlDe+8uwLATF3dPQET/XNsPiG6y/TsS3oHupF89xshvrx/V0JvdNvnB1Q3GuQHufXHWnjRRjvz6m/zRLoq2CYD2CS6Aowr5MvO8UYEQ6wj6iTVxNNe1WfJYSpMBRlAgMBAAGjZjBkMBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRae0vnaPvexM1c63wCmqUBVlEFxzAfBgNVHSMEGDAWgBRae0vnaPvexM1c63wCmqUBVlEFxzANBgkqhkiG9w0BAQsFAAOCAYEAw08A5DcoOdufB7Z5Z33Nc2foAzWNMtd3uCV8iKLlv+M01dp9JZixNdYs1FQAf9vKd+fRbALkhyIRqypSb56el1+CmmNTlihERtMGs7O3pA7sH/jlQStOD26IN2pIxZ1vJPGVRm6G3tFMjZDuo8k4LOStd4M04GkhPdGHVeeHkO7zZHb5p0BhaE3YitgvHweRXM+AvIIdOXOYr+aEdhOgDUH1NefzA5YPhFvl/0EGmWejUbs73+lev3xg7e3P4rf3KRiiepdyJ2kJLo/yo4gHi1Rw2KOuGl/phmEUp/RrY/Mg69207USE5jbIaYy5VAmp5eTxyvXQcIKwleoRpBQXNKqyqLlZkBrKkq9bbbehGmbDs+XazqVUwP13CZ+dGkn+/8+HVyNn8/ARzShCzCCj2DUhreJypuf61T+TNLBDKMsnXvkdLVRBLV1A46CeZ8HrcHVsaf1mreMAscXLRv7svaahKCOfIu030NC/1TQ0amqysuEAO9Rn8VyJZAI+1TnN';

  // Leaf "EAA Issuer Access" certificate, issued by (signed with) the Talao
  // root CA above. It is a different certificate (different DER bytes /
  // base64 string) from the root, even though it chains up to it.
  const leafCertificateSignedByRoot =
      'MIID8zCCAlugAwIBAgIUfIc4vTGzgL8FmJEjUyNrrE12toMwDQYJKoZIhvcNAQELBQAwaDELMAkGA1UEBhMCRlIxDjAMBgNVBAcMBVBhcmlzMSYwJAYDVQQKDB1UYWxhbyBMb2NhbCBUZXN0IFRydXN0IEFuY2hvcjEhMB8GA1UEAwwYVGFsYW8gTG9jYWwgVGVzdCBSb290IENBMB4XDTI2MDkwNDE2NTk1NVoXDTI3MDkwNDE2NTk1NVowgagxCzAJBgNVBAYTAkZSMRwwGgYDVQQKDBNXZWIzIERpZ2l0YWwgV2FsbGV0MRgwFgYDVQRhDA9OVFJGUi05MTAzOTk0MzUxLDAqBgNVBAsMI1dlYjMgRGlnaXRhbCBXYWxsZXQgQ29yZSBFQUEgSXNzdWVyMTMwMQYDVQQDDCpXZWIzIERpZ2l0YWwgV2FsbGV0IFRlc3QgRUFBIElzc3VlciBBY2Nlc3MwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARzhsNSBDimJC5Txlgq3EoiJCdaRHVqYCcForp97mcoSsaGgNe1IEfscHFQywXEA2NUokfoYKOJwcNWx9po2FSVo4GeMIGbMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgeAMB0GA1UdDgQWBBQ0qs4dEjbnTL45EU4xkhtNjiaONzAfBgNVHSMEGDAWgBRae0vnaPvexM1c63wCmqUBVlEFxzA7BgNVHREENDAyhjBodHRwczovL29wZW5pZDR2Yy1odWIuY29tL2lzc3Vlci9jb3JlLWVhYS1pc3N1ZXIwDQYJKoZIhvcNAQELBQADggGBALbRtoEHJzhUI5F9Wk+JS/8bfQd5f5xayMdFbCf9Ymjq/qBGKMRwU3IV8X6jJYSsykRktVZ0japKOzG9iDEACviR1WYqVOSp4uAi7tfr+bgaGL47JjRQXbP9iwISxfvLUkHFhOJsU4v1A9gcMr8LZpQEUICyZRenabiWYJw5vLExXtzgZJMO1JZMxi853dj0rXP+5qcfP6Qpl37e1uM2c8asS2Zr/n5do9GbEmlNQxQYcw4HpAJGsQXmooRNb5lLyZFb9994rV/ECngDkzvDmEfRaMEXzXV93sdr+zHF+PE1GcXQDhMREd58WpQF0bcvVZ3wU8Rj63Qw2m9P5zmvgKkir8Y4mdlpTKe3gZcbALnT+MttBrCUzC+VbOxsAPfAJTc+lRhPBGS/JoGnS4jy+3hzEEQJpXlwRY7VZQRTNxlz7hqAezpFwyExbvfMyA2PqL1Ci3d3Bzcy/qb6Ld2N8tsEDBS4EBUbD2/2/SYF39dMxntXT9+52UgiYis+heaKSw==';

  const trustedListJson = '''
{"ecosystem":"talao-wallet-network","entities":[{"description":"This an issuer access certificate","electronicAddress":{"lang":"en","uri":"mailto:contact@talao.io"},"endpoint":"https://talao.co/","id":"https://talao.co/","name":"Web3 Digital Wallet Issuer","postalAddress":{"countryName":"FR","locality":"St Ouen Marchefroy","postalCode":"28260","streetAddress":"112 rue des Tuileries"},"rootCertificates":["$rootCertificate"],"type":"issuer","vcTypes":["eu.europa.ec.eudi.pid.1","urn:eudi:pid:1","https://openid4vc-hub.com/vct/company-representative","com.openid4vc-hub.company-representative.1","urn:talao:proof-of-email","urn:talao:phone","urn:talao:proof-of-residence:1","https://openid4vc-hub.com/credentials/qtsp-service-user","org.iso.18013.5.1.mDL","org.iso.18013.5.1.mDL"],"x509_hash":["ITnqR3s7uhYqAexMtjGEYATuJfKupSjRVpc7wK04EVc"]},{"description":"This a verifier access certificate","electronicAddress":{"lang":"en","uri":"mailto:contact@talao.io"},"endpoint":"https://talao.co/","id":"https://talao.co","name":"Web3 Digital Wallet Verifier","postalAddress":{"countryName":"FR","locality":"St Ouen Marchefroy","postalCode":"28260","streetAddress":"112 rue des Tuileries"},"rootCertificates":["$rootCertificate"],"type":"verifier","vcTypes":["eu.europa.ec.eudi.pid.1","urn:eudi:pid:1","https://openid4vc-hub.com/vct/company-representative","com.openid4vc-hub.company-representative.1","urn:talao:proof-of-email","urn:talao:phone","urn:talao:proof-of-residence:1","https://openid4vc-hub.com/credentials/qtsp-service-user","org.iso.18013.5.1.mDL","org.iso.18013.5.1.mDL"],"x509_hash":["ITnqR3s7uhYqAexMtjGEYATuJfKupSjRVpc7wK04EVc"]}],"lastUpdated":"2025-07-21T11:00:00Z"}
''';

  group('getIssuerFromTrustedListByX5c', () {
    late TrustedList trustedList;

    setUp(() {
      trustedList = TrustedList.fromJson(
        jsonDecode(trustedListJson) as Map<String, dynamic>,
      );
    });

    test(
      'finds the issuer when x5c is the leaf certificate signed by the '
      'trusted root (chain-of-trust match, not a literal string match)',
      () {
        final trustedEntity = getIssuerFromTrustedListByX5c(
          x5c: [leafCertificateSignedByRoot],
          trustedList: trustedList,
        );

        expect(trustedEntity, isNotNull);
        expect(trustedEntity!.id, 'https://talao.co/');
      },
    );

    test(
      'finds the issuer when x5c literally contains the trusted root '
      'certificate',
      () {
        final trustedEntity = getIssuerFromTrustedListByX5c(
          x5c: [rootCertificate],
          trustedList: trustedList,
        );

        expect(trustedEntity, isNotNull);
        expect(trustedEntity!.id, 'https://talao.co/');
      },
    );

    test(
      'returns null when x5c has no relationship to any trusted root '
      'certificate',
      () {
        final trustedEntity = getIssuerFromTrustedListByX5c(
          x5c: const ['unrelated-certificate'],
          trustedList: trustedList,
        );

        expect(trustedEntity, isNull);
      },
    );
  });

  group('getEntityFromTrustedListByX5c', () {
    late TrustedList trustedList;

    setUp(() {
      trustedList = TrustedList.fromJson(
        jsonDecode(trustedListJson) as Map<String, dynamic>,
      );
    });

    test(
      'finds the verifier when x5c is the leaf certificate signed by the '
      'trusted root',
      () {
        final trustedEntity = getEntityFromTrustedListByX5c(
          x5c: [leafCertificateSignedByRoot],
          trustedList: trustedList,
          type: TrustedEntityType.verifier,
        );

        expect(trustedEntity, isNotNull);
        expect(trustedEntity!.id, 'https://talao.co');
      },
    );

    test('does not match an entity of a different type', () {
      final trustedEntity = getEntityFromTrustedListByX5c(
        x5c: [leafCertificateSignedByRoot],
        trustedList: trustedList,
        type: TrustedEntityType.walletProvider,
      );

      expect(trustedEntity, isNull);
    });
  });
}
