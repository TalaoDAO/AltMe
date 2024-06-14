import 'package:altme/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('XtzData', () {
    test('fromJson should create a XtzData instance from JSON', () {
      final json = {
        'price': 3.5,
        'price24H': 3.7,
        'marketCap': 1000000000.0,
        'market24H': 900000000.0,
        'volume': 5000000.0,
        'volume24H': 6000000.0,
        'updated': '2023-05-17T15:25:00Z',
      };

      final xtzData = XtzData.fromJson(json);

      expect(xtzData.price, 3.5);
      expect(xtzData.price24H, 3.7);
      expect(xtzData.marketCap, 1000000000.0);
      expect(xtzData.market24H, 900000000.0);
      expect(xtzData.volume, 5000000.0);
      expect(xtzData.volume24H, 6000000.0);
      expect(xtzData.updated, DateTime.utc(2023, 5, 17, 15, 25, 0));
    });

    test('toJson should convert a XtzData instance to JSON', () {
      final xtzData = XtzData(
        price: 3.5,
        price24H: 3.7,
        marketCap: 1000000000,
        market24H: 900000000,
        volume: 5000000,
        volume24H: 6000000,
        updated: DateTime.utc(2023, 5, 17, 15, 25, 0),
      );

      final json = xtzData.toJson();

      expect(json['price'], 3.5);
      expect(json['price24H'], 3.7);
      expect(json['marketCap'], 1000000000.0);
      expect(json['market24H'], 900000000.0);
      expect(json['volume'], 5000000.0);
      expect(json['volume24H'], 6000000.0);
      expect(json['updated'], equals('2023-05-17T15:25:00.000Z'));
    });
  });
}
