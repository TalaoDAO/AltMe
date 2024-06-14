import 'package:altme/app/shared/shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Helper Function', () {
    test('uri_list is generated correctly', () {
      const url =
          'https://app.altme.io/app/download?uri_list=https%3A%2F%2Fissuer.talao.co%2Fmy_route_to_wallet_endpoint%2F1111111111&uri_list=https%3A%2F%2Fissuer.talao.co%2Fmy_route_to_wallet_endpoint%2F2222222222';

      final uriList = generateUriList(url);

      final output = [
        'https://issuer.talao.co/my_route_to_wallet_endpoint/1111111111',
        'https://issuer.talao.co/my_route_to_wallet_endpoint/2222222222',
      ];

      expect(uriList, output);
    });
  });
}
