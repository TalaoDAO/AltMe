import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<VerificationType> verifyEncodedData(
  String issuerDid,
  String issuerKid,
  String jwt,
  ProfileCubit profileCubit,
) async {
  final OIDC4VC oidc4vc = profileCubit.state.model.oidc4vcType.getOIDC4VC;

  final VerificationType verificationType = await oidc4vc.verifyEncodedData(
    issuerDid: issuerDid,
    jwt: jwt,
    issuerKid: issuerKid,
  );
  return verificationType;
}
