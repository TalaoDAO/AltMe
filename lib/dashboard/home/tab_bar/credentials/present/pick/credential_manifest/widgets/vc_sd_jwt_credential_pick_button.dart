import 'package:altme/app/shared/issuer/models/issuer.dart';
import 'package:altme/app/shared/widget/button/my_gradient_button.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/credential_manifest/cubit/credential_manifest_pick_cubit.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/credential_manifest/view/selective_disclosure_pick_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

Widget vcSdJwtCredentialPickButton({
  required BuildContext context,
  required CredentialManifestPickState credentialManifestState,
  required Uri uri,
  required CredentialModel credential,
  required Issuer issuer,
}) {
  final l10n = context.l10n;

  final button = SafeArea(
      child: Container(
    padding: const EdgeInsets.all(16),
    child: Tooltip(
      message: l10n.credentialPickPresent,
      child: MyGradientButton(
        onPressed: !credentialManifestState.isButtonEnabled
            ? null
            : () => Navigator.of(context).pushReplacement<void, void>(
                  SelectiveDisclosurePickPage.route(
                    uri: uri,
                    issuer: issuer,
                    credential: credential,
                    credentialToBePresented:
                        credentialManifestState.filteredCredentialList[
                            credentialManifestState.selected.first],
                  ),
                ),

        /// next button because we will now choose the claims we will present
        /// from the selected credential
        text: l10n.next,
      ),
    ),
  ));
  return button;
}
