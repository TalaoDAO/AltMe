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

  if (credentialSubjectTypeList.contains(
    homeCredential.credentialSubjectType,
  )) {
    //here check for over18 and over13 to take photo for AI KYC
    if (homeCredential.credentialSubjectType == CredentialSubjectType.over18 ||
        homeCredential.credentialSubjectType == CredentialSubjectType.over13 ||
        homeCredential.credentialSubjectType ==
            CredentialSubjectType.ageRange) {
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
        // get credential from launching the url
        await context.read<HomeCubit>().launchUrl(link: homeCredential.link);
      }
    } else {
      await context.read<HomeCubit>().checkForPassBaseStatusThenLaunchUrl(
            link: homeCredential.link!,
          );
    }
  } else {
    final credentialSubjectType = homeCredential.credentialSubjectType;
    final uuid = const Uuid().v4();

    if (credentialSubjectType == CredentialSubjectType.tezotopiaMembership) {
      final uri = Uri.parse(
        '''${homeCredential.link!}$uuid?issuer=did:tz:tz1NyjrTUNxDpPaqNZ84ipGELAcTWYg6s5Du''',
      );
      await context.read<QRCodeScanCubit>().verify(uri: uri);
    } else if (credentialSubjectType ==
        CredentialSubjectType.chainbornMembership) {
      final uri = Uri.parse(
        '''${homeCredential.link!}$uuid?issuer=did:tz:tz1NyjrTUNxDpPaqNZ84ipGELAcTWYg6s5Du''',
      );
      await context.read<QRCodeScanCubit>().verify(uri: uri);
    } else {
      await LaunchUrl.launch(homeCredential.link!);
    }
  }
}
