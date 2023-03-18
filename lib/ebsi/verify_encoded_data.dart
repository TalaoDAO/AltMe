import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:secure_storage/secure_storage.dart';

Future<VerificationType> verifyEncodedData(
  String issuerDid,
  DioClient client,
  SecureStorageProvider secureStorageProvider,
  String jwt,
) async {
  final Ebsi ebsi = Ebsi(Dio());
  final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
  final privateKey = await ebsi.privateKeyFromMnemonic(mnemonic: mnemonic!);

  // final String p256PrivateKey =
  //     await getRandomP256PrivateKey(secureStorageProvider);

  final holderKid = await ebsi.getKid(null, privateKey);

  final VerificationType verificationType = await ebsi.verifyEncodedData(
    issuerDid: issuerDid,
    jwt: jwt,
    holderKid: holderKid,
  );
  return verificationType;
}
