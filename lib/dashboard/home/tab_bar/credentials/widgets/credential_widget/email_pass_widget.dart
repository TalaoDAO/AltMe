import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/lang.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class EmailPassWidget extends StatelessWidget {
  const EmailPassWidget({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final emailPassModel = credentialModel
        .credentialPreview.credentialSubjectModel as EmailPassModel;

    var emailAddress = emailPassModel.email;

    if (credentialModel.getFormat == VCFormatType.vcSdJWT.vcValue &&
        (emailAddress == null || emailAddress.isEmpty)) {
      final languageCode = context.read<LangCubit>().state.locale.languageCode;
      final mapToDisplay = SelectiveDisclosureDisplayMap(
        credentialModel: credentialModel,
        claims: null,
        isPresentation: false,
        languageCode: languageCode,
        limitDisclosure: '',
        filters: <String, dynamic>{},
        isDeveloperMode:
            context.read<ProfileCubit>().state.model.isDeveloperMode,
        selectedClaimsKeyIds: <SelectedClaimsKeyIds>[],
        onPressed: null,
      ).buildMap;

      final email = mapToDisplay['Email'];
      if (email != null && email is Map<String, dynamic>) {
        final value = email['value'];

        if (value != null) emailAddress = value.toString();
      }
    }

    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.emailProof,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      value: emailAddress,
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(
              credentialModel.expirationDate!,
            ),
    );
  }
}
