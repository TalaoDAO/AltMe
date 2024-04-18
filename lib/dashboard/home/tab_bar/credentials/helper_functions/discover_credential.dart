import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/kyc_verification/kyc_verification.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:uuid/uuid.dart';

Future<void> discoverCredential({
  required DiscoverDummyCredential dummyCredential,
  required BuildContext context,
}) async {
  if (dummyCredential.credentialSubjectType.isBlockchainAccount) {
    final credentialCubit = context.read<CredentialsCubit>();
    final walletCubit = context.read<WalletCubit>();

    final cryptoAccountData = walletCubit.state.currentAccount;

    if (cryptoAccountData != null) {
      await credentialCubit.insertAssociatedWalletCredential(
        cryptoAccountData: cryptoAccountData,
      );
    }

    return;
  }

  final profileCubit = context.read<ProfileCubit>();

  final customOidc4vcProfile = profileCubit.state.model.profileSetting
      .selfSovereignIdentityOptions.customOidc4vcProfile;

  final List<CredentialSubjectType> credentialSubjectTypeListForCheck = [
    CredentialSubjectType.defiCompliance,
    CredentialSubjectType.gender,
    CredentialSubjectType.ageRange,
    CredentialSubjectType.over65,
    CredentialSubjectType.over50,
    CredentialSubjectType.over21,
    CredentialSubjectType.over18,
    CredentialSubjectType.over15,
    CredentialSubjectType.over13,
    CredentialSubjectType.verifiableIdCard,
  ];

  if (credentialSubjectTypeListForCheck
      .contains(dummyCredential.credentialSubjectType)) {
    getLogger('discoverCredential').i(dummyCredential.credentialSubjectType);

    /// here check for over18, over15, age range and over13 to take photo for
    /// AI KYC
    if (customOidc4vcProfile.vcFormatType == VCFormatType.ldpVc &&
        dummyCredential.credentialSubjectType.checkForAIKYC) {
      /// For DefiCompliance, it is not necessary to use Yoti. Instead,
      /// we can directly proceed with Id360.
      if (dummyCredential.credentialSubjectType ==
              CredentialSubjectType.defiCompliance ||
          dummyCredential.credentialSubjectType ==
              CredentialSubjectType.livenessCard) {
        await context.read<KycVerificationCubit>().getVcByKycVerification(
              vcType: dummyCredential.credentialSubjectType.getKycVcType,
              link: dummyCredential.link!,
            );
        return;
      }

      if (profileCubit.state.model.profileType == ProfileType.enterprise) {
        final discoverCardsOptions =
            profileCubit.state.model.profileSetting.discoverCardsOptions;

        if (discoverCardsOptions != null) {
          if (discoverCardsOptions.displayOver13 ||
              discoverCardsOptions.displayOver15 ||
              discoverCardsOptions.displayOver18 ||
              discoverCardsOptions.displayOver21 ||
              discoverCardsOptions.displayOver50 ||
              discoverCardsOptions.displayOver65) {
            await LaunchUrl.launch(dummyCredential.link!);
            return;
          }
        }
      }

      LoadingView().hide();
      await Navigator.push<void>(
        context,
        ChooseVerificationMethodPage.route(
          credentialSubjectType: dummyCredential.credentialSubjectType,
          onSelectPassbase: () async {
            // start verification by KYC (ID360)
            await context.read<KycVerificationCubit>().getVcByKycVerification(
                  vcType: dummyCredential.credentialSubjectType.getKycVcType,
                  link: dummyCredential.link!,
                  onKycApproved: () async {
                    await launchUrlAfterDiscovery(
                      dummyCredential: dummyCredential,
                      context: context,
                    );
                  },
                );

            Navigator.pop(context);
          },
          onSelectKYC: () async {
            // start verification by Yoti AI
            await Navigator.of(context).push<void>(
              VerifyAgePage.route(
                credentialSubjectType: dummyCredential.credentialSubjectType,
              ),
            );
          },
        ),
      );
    } else {
      await context.read<KycVerificationCubit>().getVcByKycVerification(
            link: dummyCredential.link!,
            vcType: dummyCredential.credentialSubjectType.getKycVcType,
            onKycApproved: () async {
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
