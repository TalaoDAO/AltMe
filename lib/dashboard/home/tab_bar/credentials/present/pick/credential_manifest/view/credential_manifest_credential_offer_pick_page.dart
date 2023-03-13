import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialManifestOfferPickPage extends StatelessWidget {
  const CredentialManifestOfferPickPage({
    super.key,
    required this.uri,
    required this.credential,
    required this.issuer,
    required this.inputDescriptorIndex,
    required this.credentialsToBePresented,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final int inputDescriptorIndex;
  final List<CredentialModel> credentialsToBePresented;

  static Route<dynamic> route({
    required Uri uri,
    required CredentialModel credential,
    required Issuer issuer,
    required int inputDescriptorIndex,
    required List<CredentialModel> credentialsToBePresented,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => CredentialManifestOfferPickPage(
        uri: uri,
        credential: credential,
        issuer: issuer,
        inputDescriptorIndex: inputDescriptorIndex,
        credentialsToBePresented: credentialsToBePresented,
      ),
      settings: const RouteSettings(name: '/CredentialManifestOfferPickPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final presentationDefinition =
            credential.credentialManifest!.presentationDefinition!;
        return CredentialManifestPickCubit(
          presentationDefinition: presentationDefinition.toJson(),
          credentialList: context.read<WalletCubit>().state.credentials,
          inputDescriptorIndex: inputDescriptorIndex,
        );
      },
      child: CredentialManifestOfferPickView(
        uri: uri,
        credential: credential,
        issuer: issuer,
        inputDescriptorIndex: inputDescriptorIndex,
        credentialsToBePresented: credentialsToBePresented,
      ),
    );
  }
}

class CredentialManifestOfferPickView extends StatelessWidget {
  const CredentialManifestOfferPickView({
    super.key,
    required this.uri,
    required this.credential,
    required this.issuer,
    required this.inputDescriptorIndex,
    required this.credentialsToBePresented,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final int inputDescriptorIndex;
  final List<CredentialModel> credentialsToBePresented;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final PresentationDefinition presentationDefinition =
        credential.credentialManifest!.presentationDefinition!;

    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<CredentialManifestPickCubit,
            CredentialManifestPickState>(
          builder: (context, credentialManifestState) {
            final purpose = presentationDefinition
                .inputDescriptors[inputDescriptorIndex].purpose;

            return BlocListener<ScanCubit, ScanState>(
              listener: (context, scanState) {
                if (scanState.status == ScanStatus.loading) {
                  LoadingView().show(context: context);
                } else {
                  LoadingView().hide();
                }
              },
              child: credentialManifestState.filteredCredentialList.isEmpty
                  ? const RequiredCredentialNotFound()
                  : BasePage(
                      title: l10n.credentialPickTitle,
                      titleAlignment: Alignment.topCenter,
                      titleTrailing: const WhiteCloseButton(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      body: Column(
                        children: <Widget>[
                          Text(
                            '${inputDescriptorIndex + 1}/${presentationDefinition.inputDescriptors.length}',
                            style: Theme.of(context).textTheme.credentialSteps,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              purpose ?? l10n.credentialPickSelect,
                              style: Theme.of(context)
                                  .textTheme
                                  .credentialSubtitle,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(
                            credentialManifestState
                                .filteredCredentialList.length,
                            (index) {
                              return CredentialsListPageItem(
                                credentialModel: credentialManifestState
                                    .filteredCredentialList[index],
                                selected: credentialManifestState.selected
                                    .contains(index),
                                onTap: () => context
                                    .read<CredentialManifestPickCubit>()
                                    .toggle(index),
                              );
                            },
                          ),
                        ],
                      ),
                      navigation: credentialManifestState
                              .filteredCredentialList.isNotEmpty
                          ? SafeArea(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Tooltip(
                                  message: l10n.credentialPickPresent,
                                  child: Builder(
                                    builder: (context) {
                                      final inputDescriptor =
                                          presentationDefinition
                                                  .inputDescriptors[
                                              inputDescriptorIndex];

                                      final isOptional = inputDescriptor
                                              .constraints
                                              ?.fields
                                              ?.first
                                              .optional ??
                                          false;

                                      final bool isOngoingStep =
                                          inputDescriptorIndex + 1 !=
                                              presentationDefinition
                                                  .inputDescriptors.length;

                                      if (isOptional) {
                                        return MyGradientButton(
                                          onPressed: () => present(
                                            context: context,
                                            credentialManifestState:
                                                credentialManifestState,
                                            presentationDefinition:
                                                presentationDefinition,
                                            skip: credentialManifestState
                                                .selected.isEmpty,
                                          ),
                                          text: credentialManifestState
                                                  .selected.isEmpty
                                              ? l10n.skip
                                              : isOngoingStep
                                                  ? l10n.next
                                                  : l10n.credentialPickPresent,
                                        );
                                      } else {
                                        return MyGradientButton(
                                          onPressed: credentialManifestState
                                                  .selected.isEmpty
                                              ? null
                                              : () => present(
                                                    context: context,
                                                    credentialManifestState:
                                                        credentialManifestState,
                                                    presentationDefinition:
                                                        presentationDefinition,
                                                    skip: false,
                                                  ),
                                          text: isOngoingStep
                                              ? l10n.next
                                              : l10n.credentialPickPresent,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
            );
          },
        );
      },
    );
  }

  Future<void> present({
    required BuildContext context,
    required CredentialManifestPickState credentialManifestState,
    required PresentationDefinition presentationDefinition,
    required bool skip,
  }) async {
    late List<CredentialModel> updatedCredentials;
    if (skip) {
      updatedCredentials = List.of(
        credentialsToBePresented,
      );
    } else {
      final selectedCredentials = credentialManifestState.selected
          .map(
            (selectedIndex) =>
                credentialManifestState.filteredCredentialList[selectedIndex],
          )
          .toList();

      updatedCredentials = List.of(
        credentialsToBePresented,
      )..addAll(selectedCredentials);
    }

    getLogger('present')
        .i('credential to presented - ${updatedCredentials.length}');

    if (inputDescriptorIndex + 1 !=
        presentationDefinition.inputDescriptors.length) {
      await Navigator.of(context).pushReplacement<void, void>(
        CredentialManifestOfferPickPage.route(
          uri: uri,
          credential: credential,
          issuer: issuer,
          inputDescriptorIndex: inputDescriptorIndex + 1,
          credentialsToBePresented: updatedCredentials,
        ),
      );
    } else {
      /// Authenticate
      bool authenticated = false;
      await Navigator.of(context).push<void>(
        PinCodePage.route(
          restrictToBack: false,
          isValidCallback: () {
            authenticated = true;
          },
        ),
      );

      if (!authenticated) {
        return;
      }

      await context.read<ScanCubit>().credentialOffer(
            uri: uri,
            credentialModel: credential,
            keyId: SecureStorageKeys.ssiKey,
            credentialsToBePresented: updatedCredentials,
            issuer: issuer,
          );
    }
  }
}
