import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlockchainNetwork', () {
    test('fromJson should create a BlockchainNetwork instance from JSON', () {
      final json = {
        'networkname': 'TestNet',
        'apiUrl': 'https://example.com/api',
        'rpcNodeUrl': 'https://rpc.example.com',
        'title': 'Test Network',
        'subTitle': 'Subtitle',
        'type': 'ethereum',
        'apiKey': 'apikey',
      };

      final blockchainNetwork = BlockchainNetwork.fromJson(json);

      expect(blockchainNetwork.networkname, 'TestNet');
      expect(blockchainNetwork.apiUrl, 'https://example.com/api');
      expect(blockchainNetwork.rpcNodeUrl, 'https://rpc.example.com');
      expect(blockchainNetwork.title, 'Test Network');
      expect(blockchainNetwork.subTitle, 'Subtitle');
      expect(blockchainNetwork.type, BlockchainType.ethereum);
      expect(blockchainNetwork.apiKey, 'apikey');
    });

    test('toJson should convert a BlockchainNetwork instance to JSON', () {
      const blockchainNetwork = BlockchainNetwork(
        networkname: 'TestNet',
        apiUrl: 'https://example.com/api',
        rpcNodeUrl: 'https://rpc.example.com',
        title: 'Test Network',
        subTitle: 'Subtitle',
        type: BlockchainType.ethereum,
        apiKey: 'apikey',
      );

      final json = blockchainNetwork.toJson();

      expect(json['networkname'], 'TestNet');
      expect(json['apiUrl'], 'https://example.com/api');
      expect(json['rpcNodeUrl'], 'https://rpc.example.com');
      expect(json['title'], 'Test Network');
      expect(json['subTitle'], 'Subtitle');
      expect(json['type'], 'ethereum');
      expect(json['apiKey'], 'apikey');
    });
  });
}
