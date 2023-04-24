import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

Future<void> discoverCredential({
  required DiscoverDummyCredential dummyCredential,
  required BuildContext context,
}) async {
  final List<CredentialSubjectType> credentialSubjectTypeList =
      List.of(CredentialCategory.identityCards.discoverCredentialSubjectTypes);

  /// items to remove to bypass KYC
  credentialSubjectTypeList
    ..remove(CredentialSubjectType.emailPass)
    ..remove(CredentialSubjectType.phonePass)
    ..remove(CredentialSubjectType.twitterCard);

  if (credentialSubjectTypeList
      .contains(dummyCredential.credentialSubjectType)) {
    getLogger('discoverCredential').i(dummyCredential.credentialSubjectType);

    /// here check for over18, over15, age range and over13 to take photo for
    /// AI KYC
    if (dummyCredential.credentialSubjectType.checkForAIKYC) {
      await Navigator.of(context).push<void>(
        VerifyAgePage.route(
          credentialSubjectType: dummyCredential.credentialSubjectType,
        ),
      );
      // await Navigator.push<void>(
      //   context,
      //   ChooseVerificationMethodPage.route(
      //     credentialSubjectType: dummyCredential.credentialSubjectType,
      //     onSelectPassbase: () async {
      //       await context.read<HomeCubit>().checkForPassBaseStatusThenLaunchUrl(
      //             link: dummyCredential.link!,
      //             onPassBaseApproved: () async {
      //               await launchUrlAfterDiscovery(
      //                 dummyCredential: dummyCredential,
      //                 context: context,
      //               );
      //             },
      //           );

      //       Navigator.pop(context);
      //     },
      //     onSelectKYC: () async {
      //       // start verification by Yoti AI
      //       await Navigator.of(context).push<void>(
      //         VerifyAgePage.route(
      //           credentialSubjectType: dummyCredential.credentialSubjectType,
      //         ),
      //       );
      //     },
      //   ),
      // );
    } else {
      await context.read<HomeCubit>().checkForPassBaseStatusThenLaunchUrl(
            link: dummyCredential.link!,
            onPassBaseApproved: () async {
              await launchUrlAfterDiscovery(
                dummyCredential: dummyCredential,
                context: context,
              );
            },
          );
    }
  } else {
    await launchUrlAfterDiscovery(
      dummyCredential: dummyCredential,
      context: context,
    );
  }
}

Future<void> launchUrlAfterDiscovery({
  required DiscoverDummyCredential dummyCredential,
  required BuildContext context,
}) async {
  if (dummyCredential.credentialSubjectType.byPassDeepLink) {
    final uuid = const Uuid().v4();
    final uri = Uri.parse(
      '''${dummyCredential.link!}$uuid?issuer=did:tz:tz1NyjrTUNxDpPaqNZ84ipGELAcTWYg6s5Du''',
    );
    await context.read<QRCodeScanCubit>().verify(uri: uri, isScan: false);
  } else {
    await LaunchUrl.launch(dummyCredential.link!);
  }
}
