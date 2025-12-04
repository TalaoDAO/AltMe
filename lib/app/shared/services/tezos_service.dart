import 'package:tezart/tezart.dart';

class TezosService {
  Future<Keystore> getKeystore({required String secretKey}) async {
    return Keystore.fromSecretKey(secretKey);
  }

  Future<List<String>> getKeysFromSecretKey({required String secretKey}) async {
    final keystore = await getKeystore(secretKey: secretKey);
    return [keystore.secretKey, keystore.publicKey, keystore.address];
  }

  Future<String> signPayload({
    required String secretKey,
    required String payload,
  }) async {
    final keystore = await getKeystore(secretKey: secretKey);
    final signature = Signature.fromHex(data: payload, keystore: keystore);
    return signature.edsig;
  }

  Future<OperationsList> callContract({
    required String rpcUrl,
    required String secretKey,
    required String contractAddress,
    required int amount,
    required String entrypoint,
    required String params,
  }) async {
    final client = TezartClient(rpcUrl);
    final keystore = await getKeystore(secretKey: secretKey);

    final contract = Contract(
      contractAddress: contractAddress,
      rpcInterface: client.rpcInterface,
    );

    final operationList = await contract.callOperation(
      entrypoint: entrypoint,
      amount: amount,
      params: params,
      source: keystore,
      publicKey: keystore.publicKey,
    );

    return operationList;
  }
}
