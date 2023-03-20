import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';

Future<VerificationType> verifyEncodedData(
  String issuerDid,
  String issuerKid,
  String jwt,
) async {
  final Ebsi ebsi = Ebsi(Dio());

  final VerificationType verificationType = await ebsi.verifyEncodedData(
    issuerDid: issuerDid,
    jwt: jwt,
    issuerKid: issuerKid,
  );
  return verificationType;
}
