import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

Future<void> getAndAddDefferedCredential({
  required CredentialModel credentialModel,
  required CredentialsCubit credentialsCubit,
  required OIDC4VC oidc4vc,
  required JWTDecode jwtDecode,
  required BlockchainType blockchainType,
  required String? issuer,
}) async {
  final dynamic encodedCredentialOrFutureToken =
      await oidc4vc.getDeferredCredential(
    acceptanceToken: credentialModel.pendingInfo!.acceptanceToken,
    deferredCredentialEndpoint:
        credentialModel.pendingInfo!.deferredCredentialEndpoint,
  );

  await addOIDC4VCCredential(
    encodedCredentialFromOIDC4VC: encodedCredentialOrFutureToken,
    credentialsCubit: credentialsCubit,
    issuer: issuer,
    credentialType: credentialModel.credentialPreview.type[0],
    isLastCall: true,
    format: credentialModel.pendingInfo!.format,
    credentialIdToBeDeleted: credentialModel.id,
    openIdConfiguration: null,
    jwtDecode: jwtDecode,
    blockchainType: blockchainType,
  );
}
