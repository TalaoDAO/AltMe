import 'package:altme/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('TezosNetwork', () {
    test('fromJson should create a TezosNetwork instance from JSON', () {
      final json = {
        'networkname': 'TestNet',
        'apiUrl': 'https://example.com/api',
        'rpcNodeUrl': 'https://rpc.example.com',
        'title': 'Test Network',
        'subTitle': 'Subtitle',
        'type': 'tezos',
        'apiKey': 'apikey',
      };

      final tezosNetwork = TezosNetwork.fromJson(json);

      expect(tezosNetwork.networkname, 'TestNet');
      expect(tezosNetwork.apiUrl, 'https://example.com/api');
      expect(tezosNetwork.rpcNodeUrl, 'https://rpc.example.com');
      expect(tezosNetwork.title, 'Test Network');
      expect(tezosNetwork.subTitle, 'Subtitle');
      expect(tezosNetwork.type, BlockchainType.tezos);
      expect(tezosNetwork.apiKey, 'apikey');
    });

    test('toJson should convert a TezosNetwork instance to JSON', () {
      const tezosNetwork = TezosNetwork(
        networkname: 'TestNet',
        apiUrl: 'https://example.com/api',
        rpcNodeUrl: 'https://rpc.example.com',
        title: 'Test Network',
        subTitle: 'Subtitle',
        type: BlockchainType.tezos,
        apiKey: 'apikey',
        isMainNet: false,
        chainId: 0,
      );

      final json = tezosNetwork.toJson();

      expect(json['networkname'], 'TestNet');
      expect(json['apiUrl'], 'https://example.com/api');
      expect(json['rpcNodeUrl'], 'https://rpc.example.com');
      expect(json['title'], 'Test Network');
      expect(json['subTitle'], 'Subtitle');
      expect(json['type'], 'tezos');
      expect(json['apiKey'], 'apikey');
    });
  });
}
