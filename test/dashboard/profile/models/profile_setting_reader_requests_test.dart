import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

void main() {
  Map<String, dynamic> configuration({List<Object>? readerRequests}) =>
      jsonDecode(
            jsonEncode({
              ...ProfileSetting.initial().toJson(),
              'readerRequests': ?readerRequests,
            }),
          )
          as Map<String, dynamic>;

  group('ProfileSetting.readerRequests', () {
    test('reads the readerRequests a backend configuration sends', () {
      final setting = ProfileSetting.fromJson(
        configuration(
          readerRequests: [
            {
              'id': 'f4a37b0a-84f9-47d6-8068-a61a25999a8f',
              'name': 'PID',
              'query': {
                'eu.europa.ec.eudi.pid.1': {
                  'eu.europa.ec.eudi.pid.1': {
                    'birth_date': false,
                    'family_name': false,
                    'given_name': false,
                  },
                },
              },
            },
          ],
        ),
      );

      expect(setting.readerRequests, const [
        ReaderRequest(
          id: 'f4a37b0a-84f9-47d6-8068-a61a25999a8f',
          name: 'PID',
          query: {
            eudiPidDocType: {
              eudiPidDocType: {
                'birth_date': false,
                'family_name': false,
                'given_name': false,
              },
            },
          },
        ),
      ]);
    });

    test('is null when the configuration has none', () {
      expect(ProfileSetting.fromJson(configuration()).readerRequests, isNull);
    });

    test('survives the round trip through secure storage', () {
      final setting = ProfileSetting.initial().copyWith(
        readerRequests: defaultReaderRequests,
      );

      final stored = ProfileSetting.fromJson(
        jsonDecode(jsonEncode(setting.toJson())) as Map<String, dynamic>,
      );

      expect(stored.readerRequests, defaultReaderRequests);
    });

    test('the Default profile asks for the PID and the mDL', () {
      final profile = ProfileModel.defaultOne(
        walletProtectionType: WalletProtectionType.pinCode,
        isDeveloperMode: false,
        clientId: null,
        clientSecret: null,
      );

      expect(
        profile.profileSetting.readerRequests?.map((request) => request.id),
        ['pid-basic', 'mdl-basic'],
      );
      expect(profile.profileSetting.readerRequests?.last.docTypes, [
        'org.iso.18013.5.1.mDL',
      ]);
    });
  });
}
