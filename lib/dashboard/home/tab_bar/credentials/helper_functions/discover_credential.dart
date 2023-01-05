import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

Future<void> discoverCredential({
  required HomeCredential homeCredential,
  required BuildContext context,
}) async {
  final List<CredentialSubjectType> credentialSubjectTypeList =
      List.of(DiscoverList.identityCategories);

  /// items to remove to bypass KYC
  credentialSubjectTypeList.remove(CredentialSubjectType.emailPass);
  credentialSubjectTypeList.remove(CredentialSubjectType.phonePass);

  if (credentialSubjectTypeList
      .contains(homeCredential.credentialSubjectType)) {
    getLogger('discoverCredential').i(homeCredential.credentialSubjectType);
    //here check for over18 and over13 to take photo for AI KYC
    if (homeCredential.credentialSubjectType.checkForAIKYC) {
      final passbaseStatus =
          await context.read<HomeCubit>().checkPassbaseStatus();
      if (passbaseStatus != PassBaseStatus.approved) {
        // start verification by Yoti AI
        await Navigator.of(context).push<void>(
          VerifyAgePage.route(
            credentialSubjectType: homeCredential.credentialSubjectType,
          ),
        );
      } else {
        await launchUrlAfterDiscovery(
          homeCredential: homeCredential,
          context: context,
        );
      }
    } else {
      await context.read<HomeCubit>().checkForPassBaseStatusThenLaunchUrl(
            link: homeCredential.link!,
            onPassBaseApproved: () async {
              await launchUrlAfterDiscovery(
                homeCredential: homeCredential,
                context: context,
              );
            },
          );
    }
  } else {
    await launchUrlAfterDiscovery(
      homeCredential: homeCredential,
      context: context,
    );
  }
}

Future<void> launchUrlAfterDiscovery({
  required HomeCredential homeCredential,
  required BuildContext context,
}) async {
  if (homeCredential.credentialSubjectType.byPassDeepLink) {
    final uuid = const Uuid().v4();
    final uri = Uri.parse(
      '''${homeCredential.link!}$uuid?issuer=did:tz:tz1NyjrTUNxDpPaqNZ84ipGELAcTWYg6s5Du''',
    );
    await context.read<QRCodeScanCubit>().verify(uri: uri, isScan: false);
  } else {
    await LaunchUrl.launch(homeCredential.link!);
  }
}
