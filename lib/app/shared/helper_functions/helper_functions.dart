import 'dart:convert';
import 'dart:io';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convert/convert.dart';
import 'package:dartez/dartez.dart';
import 'package:json_path/json_path.dart';
import 'package:web3dart/web3dart.dart';

String generateDefaultAccountName(
  int accountIndex,
  List<String> accountNameList,
) {
  final defaultAccountName = 'My account ${accountIndex + 1}';
  final containSameName = accountNameList.contains(defaultAccountName);
  if (containSameName) {
    return generateDefaultAccountName(accountIndex + 1, accountNameList);
  } else {
    return defaultAccountName;
  }
}

bool isAndroid() {
  return Platform.isAndroid;
}

String getIssuerDid({required Uri uriToCheck}) {
  String did = '';
  uriToCheck.queryParameters.forEach((key, value) {
    if (key == 'issuer') {
      did = value;
    }
  });
  return did;
}

bool isEbsiIssuer(CredentialModel credentialModel) {
  return credentialModel.issuer.startsWith('did:ebsi');
}

bool isValidPrivateKey(String value) {
  return value.startsWith('edsk') ||
      value.startsWith('spsk') ||
      value.startsWith('p2sk') ||
      value.startsWith('0x');
}

KeyStoreModel getKeysFromSecretKey({required String secretKey}) {
  final List<String> sourceKeystore = Dartez.getKeysFromSecretKey(secretKey);

  return KeyStoreModel(
    secretKey: sourceKeystore[0],
    publicKey: sourceKeystore[1],
    publicKeyHash: sourceKeystore[2],
  );
}

String stringToHexPrefixedWith05({required String payload}) {
  final String formattedInput = <String>[
    'Tezos Signed Message:',
    'altme.io',
    DateTime.now().toString(),
    payload,
  ].join(' ');

  final String bytes = char2Bytes(formattedInput);

  const String prefix = '05';
  const String stringIsHex = '0100';
  final String bytesOfByteLength = char2Bytes(bytes.length.toString());

  final payloadBytes = '$prefix$stringIsHex$bytesOfByteLength$bytes';

  return payloadBytes;
}

String char2Bytes(String text) {
  final List<int> encode = utf8.encode(text);
  final String bytes = hex.encode(encode);
  return bytes;
}

Future<bool> isConnected() async {
  final log = getLogger('Check Internet Connection');
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  log.e('No Internet Connection');
  return false;
}

double formatEthAmount({
  required BigInt amount,
  EtherUnit fromUnit = EtherUnit.wei,
  EtherUnit toUnit = EtherUnit.ether,
}) {
  if (amount == BigInt.zero) return 0;

  final String ethAmount = EtherAmount.fromUnitAndValue(fromUnit, amount)
      .getValueInUnit(toUnit)
      .toStringAsFixed(6)
      .characters
      .take(7)
      .toString();

  return double.parse(ethAmount);
}

String getCredentialName(String constraints) {
  final dynamic constraintsJson = jsonDecode(constraints);
  final fieldsPath = JsonPath(r'$..fields');
  final dynamic credentialField = fieldsPath
      .read(constraintsJson)
      .first
      .value
      .where(
        (dynamic e) => e['path'].toString() == r'[$.credentialSubject.type]',
      )
      .toList()
      .first;
  return credentialField['filter']['pattern'] as String;
}

String getIssuersName(String constraints) {
  final dynamic constraintsJson = jsonDecode(constraints);
  final fieldsPath = JsonPath(r'$..fields');
  final dynamic issuerField = fieldsPath
      .read(constraintsJson)
      .first
      .value
      .where(
        (dynamic e) => e['path'].toString() == r'[$.issuer]',
      )
      .toList()
      .first;
  return issuerField['filter']['pattern'] as String;
}
