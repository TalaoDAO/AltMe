import 'package:altme/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('PolygonIdNetwork Extension Tests', () {
    test('name should return correct network name', () {
      expect(PolygonIdNetwork.PolygonMainnet.name, 'Polygon Main');
      expect(PolygonIdNetwork.PolygonMumbai.name, 'Polygon Mumbai');
    });

    test('tester should return correct tester string', () {
      expect(PolygonIdNetwork.PolygonMainnet.tester, 'polygon:main');
      expect(PolygonIdNetwork.PolygonMumbai.tester, 'polygon:mumbai');
    });

    test('oppositeNetwork should return correct opposite network', () {
      expect(
          PolygonIdNetwork.PolygonMainnet.oppositeNetwork, 'mumbai(testnet)');
      expect(PolygonIdNetwork.PolygonMumbai.oppositeNetwork, 'mainnet');
    });
  });
}
