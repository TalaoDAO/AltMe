import 'package:altme/app/app.dart';
//import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/kyc_verification/kyc_verification.dart';
//import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

Future<void> discoverCredential({
  required DiscoverDummyCredential dummyCredential,
  required BuildContext context,
}) async {
  // if (dummyCredential.credentialSubjectType.isBlockchainAccount) {
  //   final credentialCubit = context.read<CredentialsCubit>();
  //   final walletCubit = context.read<WalletCubit>();
  //   final qrCodeScanCubit = context.read<QRCodeScanCubit>();

  //   final cryptoAccountData = walletCubit.state.currentAccount;

  //   if (cryptoAccountData != null) {
  //     await credentialCubit.insertAssociatedWalletCredential(
  //       cryptoAccountData: cryptoAccountData,
  //       qrCodeScanCubit: qrCodeScanCubit,
  //     );
  //   }

  //   return;
  // }

  final List<CredentialSubjectType> credentialSubjectTypeListForCheck = [
    CredentialSubjectType.gender,
    CredentialSubjectType.ageRange,
    CredentialSubjectType.verifiableIdCard,
  ];

  if (credentialSubjectTypeListForCheck.contains(
    dummyCredential.credentialSubjectType,
  )) {
    getLogger('discoverCredential').i(dummyCredential.credentialSubjectType);

    // start verification by KYC (ID360)
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
