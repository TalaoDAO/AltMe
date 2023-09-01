import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:altme/oidc4vc/oidc4vc.dart';

Future<void> getAndAddDefferedCredential({
  required CredentialModel credentialModel,
  required OIDC4VCType oidc4vcType,
  required CredentialsCubit credentialsCubit,
  required DioClient dioClient,
}) async {
  final (_, issuer) = await getIssuerAndPreAuthorizedCode(
    oidc4vcType: oidc4vcType,
    scannedResponse: credentialModel.pendingInfo!.url,
    dioClient: dioClient,
  );

  final dynamic encodedCredentialOrFutureToken =
      await oidc4vcType.getOIDC4VC.getDeferredCredential(
    acceptanceToken: credentialModel.pendingInfo!.acceptanceToken,
    deferredCredentialEndpoint:
        credentialModel.pendingInfo!.deferredCredentialEndpoint,
  );

  await addOIDC4VCCredential(
    encodedCredentialFromOIDC4VC: encodedCredentialOrFutureToken,
    credentialsCubit: credentialsCubit,
    oidc4vcType: oidc4vcType,
    issuer: issuer,
    credentialType: credentialModel.credentialPreview.type[0],
    isLastCall: true,
    format: credentialModel.pendingInfo!.format,
    credentialIdToBeDeleted: credentialModel.id,
  );
}
