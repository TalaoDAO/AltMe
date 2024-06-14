import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ethPrice returns correct URL', () {
    const symbol = 'ETH';
    const expectedUrl =
        'https://min-api.cryptocompare.com/data/price?fsym=$symbol&tsyms=USD';
    expect(Urls.ethPrice(symbol), expectedUrl);
  });
}
