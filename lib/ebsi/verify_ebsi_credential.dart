import 'package:altme/app/app.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:secure_storage/secure_storage.dart';

Future<VerificationType> isEbsiCredentialVerified(
  String issuerDid,
  DioClient client,
  SecureStorageProvider secureStorageProvider,
  String vcJwt,
) async {
  final Ebsi ebsi = Ebsi(Dio());

  final String p256PrivateKey =
      await getRandomP256PrivateKey(secureStorageProvider);

  final holderKid = await ebsi.getKid(null, p256PrivateKey);

  final VerificationType verificationType = await ebsi.verifyCredential(
    issuerDid: issuerDid,
    vcJwt: vcJwt,
    holderKid: holderKid,
  );
  return verificationType;
}
