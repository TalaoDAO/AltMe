import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';

Future<VerificationType> isEbsiCredentialVerified(
  String issuerDid,
  DioClient client,
  String vcJwt,
) async {
  final Ebsi ebsi = Ebsi(Dio());
  final VerificationType verificationType = await ebsi.verifyCredential(
    issuerDid: issuerDid,
    vcJwt: vcJwt,
  );
  return verificationType;
}
