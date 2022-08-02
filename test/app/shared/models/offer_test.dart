import 'package:altme/dashboard/home/tab_bar/credentials/models/voucher/offer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Offer model test', () {
    test('default constructor work properly', () {
      final offer = Offer('value', 'currency');
      expect(offer.value, 'value');
      expect(offer.currency, 'currency');
      expect(
        offer.toJson(),
        <String, dynamic>{'value': 'value', 'currency': 'currency'},
      );
    });

    test('fromJson constructor work properly', () {
      const json = <String, dynamic>{'value': 'value', 'currency': 'currency'};
      final offer = Offer.fromJson(json);
      expect(offer.value, 'value');
      expect(offer.currency, 'currency');
      expect(
        offer.toJson(),
        json,
      );
    });
  });
}
