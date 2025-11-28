import 'package:altme/app/app.dart';
import 'package:altme/app/shared/alert_message/exception_message.dart';
import 'package:altme/app/shared/alert_message/message_cubit.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/blockchain/blockchain_credential_subject_model/blockchain_credential_subject_model.dart';
import 'package:altme/oidc4vp_transaction/widget/disclosure_detail.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/selective_disclosure/helper_functions/selective_disclosure_display_map.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttestationList extends StatelessWidget {
  const AttestationList({super.key, required this.uri});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageAccountsCubit, ManageAccountsState>(
      builder: (context, state) {
        final account = state.cryptoAccount.data[state.currentCryptoIndex];
        return FutureBuilder<List<CredentialModel>>(
          future: _initialize(context, account),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              LoadingView().hide();
              final error = snapshot.error! as ExceptionMessage;
              context.read<MessageCubit>().error(error);
              return Center(child: Text(error.error));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final credential = snapshot.data![index];
                  final filteredCredential = credential.copyWith(
                    jwt: credential.selectiveDisclosureJwt,
                  );
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        HomeCredentialItem(credentialModel: credential),
                        DisclosureDetail(credentialModel: filteredCredential),
                      ],
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<List<CredentialModel>> _initialize(
    BuildContext context,
    CryptoAccountData currentAccount,
  ) async {
    final qRCodeScanCubit = context.read<QRCodeScanCubit>();
    final (responseType, keys) = await qRCodeScanCubit
        .preparePresentationProcess(uri);
    final (credentialPreview, host) = await qRCodeScanCubit.prepareOIDC4VPFlow(
      keys: keys,
      uri: qRCodeScanCubit.state.uri!,
    );
    final profileModel = context.read<ProfileCubit>().state.model;
    final presentationDefinition =
        credentialPreview.credentialManifest!.presentationDefinition!;
    final credentialsToBePresented = <CredentialModel>[];
    final issuer = Issuer.emptyIssuer(host);
    int index = 0;
    while (index < presentationDefinition.inputDescriptors.length) {
      final credentialManifestPickCubit = CredentialManifestPickCubit(
        credential: credentialPreview,
        credentialList: context.read<CredentialsCubit>().state.credentials,
        inputDescriptorIndex: index,
        formatsSupported:
            profileModel
                .profileSetting
                .selfSovereignIdentityOptions
                .customOidc4vcProfile
                .formatsSupported ??
            [],
        profileType: profileModel.profileType,
      );
      if (credentialManifestPickCubit.state.filteredCredentialList.isEmpty) {
        throw ExceptionMessage(
          error: 'Credential not found',
          errorDescription: 'No suitable credential found in the wallet.',
        );
      }

      /// for sd-jwt we only support single credentials right now
      /// skip is not considered for sd-jwt right now
      late CredentialModel firstOne;
      // if all credentials in
      // credentialManifestPickCubit.state.filteredCredentialList
      // have credentialPreview.credentialsSubjectModel.credentialCategory
      // equal to "blockchainAccountsCards" then firstOne is the first
      // credential with credentialPreview.credentialsSubjectModel.associatedAdd
      // equal to selected crypto account.
      if (credentialManifestPickCubit.state.filteredCredentialList.every(
        (credential) =>
            credential.credentialPreview.credentialSubjectModel
                is BlockchainCredentialSubjectModel,
      )) {
        firstOne = credentialManifestPickCubit.state.filteredCredentialList
            .firstWhere(
              (credential) {
                final CredentialSubjectModel credentialSubjectModel =
                    credential.credentialPreview.credentialSubjectModel;
                if (credentialSubjectModel is EthereumAssociatedAddressModel) {
                  return credentialSubjectModel.associatedAddress ==
                      currentAccount.walletAddress;
                }
                return false;
              },
              orElse: () {
                throw ExceptionMessage(
                  error: 'No valid crypto account found',
                  errorDescription:
                      'No suitable crypto account found in the wallet.',
                );
              },
            );
      } else {
        firstOne = credentialManifestPickCubit.state.filteredCredentialList[0];
      }

      final selectiveDisclosureCubit = context.read<SelectiveDisclosureCubit>();
      selectiveDisclosureCubit.dataFromPresentation(
        credentialModel: firstOne,
        presentationDefinition: presentationDefinition,
      );

      SelectiveDisclosureDisplayMap(
        credentialModel: firstOne,
        isPresentation: true,
        languageCode: 'en',
        limitDisclosure: selectiveDisclosureCubit.state.limitDisclosure ?? '',
        filters: selectiveDisclosureCubit.state.filters ?? {},
        isDeveloperMode: context
            .read<ProfileCubit>()
            .state
            .model
            .isDeveloperMode,
        selectedClaimsKeyIds: [],
        onPressed: (claimKey, claimKeyId, threeDotValue, sd) {
          selectiveDisclosureCubit.disclosureAction(
            claimsKey: claimKey,
            credentialModel: firstOne,
            threeDotValue: threeDotValue,
            claimKeyId: claimKeyId,
            sd: sd,
          );
        },
        displayMode: context
            .read<ProfileCubit>()
            .state
            .model
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile
            .displayMode,
      ).buildMap;

      /// create the new jwt with selected disclosure
      final encryptedValues = firstOne.jwt
          ?.split('~')
          .where((element) => element.isNotEmpty)
          .toList();

      if (encryptedValues != null) {
        var newJwt = '${encryptedValues[0]}~';

        for (final index
            in selectiveDisclosureCubit.state.selectedSDIndexInJWT) {
          newJwt = '$newJwt${encryptedValues[index + 1]}~';
        }

        final CredentialModel newModel = firstOne.copyWith(
          selectiveDisclosureJwt: newJwt,
        );

        final credToBePresented = [newModel];

        credentialsToBePresented.addAll(credToBePresented);
      } else {
        throw ExceptionMessage(
          error: 'invalid_request',
          errorDescription: 'Issue with the disclosure encryption of jwt.',
        );
      }

      index++;
    }
    context.read<ScanCubit>().updateCredentialsToBePresented(
      credentialPresentation: credentialPreview,
      presentationIssuer: issuer,
      credentialsToBePresented: credentialsToBePresented,
    );
    LoadingView().hide();
    return credentialsToBePresented;
  }
}
