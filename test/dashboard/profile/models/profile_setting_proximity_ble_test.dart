import 'dart:convert';

import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

void main() {
  group('SelfSovereignIdentityOptions proximity BLE modes', () {
    test('a stored profile without them offers both modes', () {
      final json =
          jsonDecode(jsonEncode(ProfileSetting.initial().toJson()))
              as Map<String, dynamic>;
      final ssi = json['selfSovereignIdentityOptions'] as Map<String, dynamic>
        ..remove('proximityPeripheralServer')
        ..remove('proximityCentralClient');
      expect(ssi.containsKey('proximityCentralClient'), isFalse);

      final options = ProfileSetting.fromJson(
        json,
      ).selfSovereignIdentityOptions;

      expect(options.proximityPeripheralServer, isTrue);
      expect(options.proximityCentralClient, isTrue);
      expect(options.proximityBleModes, {
        ProximityBleMode.peripheralServer,
        ProximityBleMode.centralClient,
      });
    });

    test('a wallet provider configuration can turn one off', () {
      final options = SelfSovereignIdentityOptions.fromJson({
        ...SelfSovereignIdentityOptions.provider().toJson(),
        'customOidc4vcProfile': CustomOidc4VcProfile.provider().toJson(),
        'proximityPeripheralServer': false,
      });

      expect(options.proximityPeripheralServer, isFalse);
      expect(options.proximityBleModes, {ProximityBleMode.centralClient});
    });

    test('survive the round trip through secure storage', () {
      final setting = ProfileSetting.initial();
      final changed = setting.copyWith(
        selfSovereignIdentityOptions: setting.selfSovereignIdentityOptions
            .copyWith(proximityCentralClient: false),
      );

      final stored = ProfileSetting.fromJson(
        jsonDecode(jsonEncode(changed.toJson())) as Map<String, dynamic>,
      );

      expect(stored.selfSovereignIdentityOptions.proximityBleModes, {
        ProximityBleMode.peripheralServer,
      });
    });
  });
}
