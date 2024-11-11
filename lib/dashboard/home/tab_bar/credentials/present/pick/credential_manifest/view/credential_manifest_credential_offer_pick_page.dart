import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';

import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

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
        return CredentialManifestPickCubit(
          credential: credential,
          credentialList: context.read<CredentialsCubit>().state.credentials,
          inputDescriptorIndex: inputDescriptorIndex,
          vcFormatType: context
              .read<ProfileCubit>()
              .state
              .model
              .profileSetting
              .selfSovereignIdentityOptions
              .customOidc4vcProfile
              .vcFormatType,
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

class CredentialManifestOfferPickView extends StatefulWidget {
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
  State<CredentialManifestOfferPickView> createState() =>
      _CredentialManifestOfferPickViewState();
}

class _CredentialManifestOfferPickViewState
    extends State<CredentialManifestOfferPickView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isVcSdJWT = context
              .read<CredentialManifestPickCubit>()
              .state
              .filteredCredentialList
              .firstOrNull
              ?.getFormat ==
          VCFormatType.vcSdJWT.vcValue;

      if (isVcSdJWT) {
        final element = context
            .read<CredentialManifestPickCubit>()
            .state
            .filteredCredentialList;

        final containsSingleElement = element.isNotEmpty && element.length == 1;
        if (containsSingleElement) {
          final PresentationDefinition? presentationDefinition = context
              .read<CredentialManifestPickCubit>()
              .state
              .presentationDefinition;

          if (presentationDefinition != null) {
            context.read<CredentialManifestPickCubit>().toggle(
                  index: 0,
                  inputDescriptor: presentationDefinition
                      .inputDescriptors[widget.inputDescriptorIndex],
                  isVcSdJWT: isVcSdJWT,
                );

            final credentialManifestState =
                context.read<CredentialManifestPickCubit>().state;
            final credentialToBePresented = credentialManifestState
                .filteredCredentialList[credentialManifestState.selected.first];

            Navigator.of(context).pushReplacement<void, void>(
              SelectiveDisclosurePickPage.route(
                uri: widget.uri,
                issuer: widget.issuer,
                credential: widget.credential,
                credentialToBePresented: credentialToBePresented,
                presentationDefinition: presentationDefinition,
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<CredentialManifestPickCubit,
        CredentialManifestPickState>(
      listener: (context, state) {
        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }
      },
      builder: (context, credentialManifestState) {
        final PresentationDefinition? presentationDefinition =
            credentialManifestState.presentationDefinition;

        final isVcSdJWT = credentialManifestState
                .filteredCredentialList.firstOrNull?.getFormat ==
            VCFormatType.vcSdJWT.vcValue;

        return BlocListener<ScanCubit, ScanState>(
          listener: (context, scanState) {
            if (scanState.status == ScanStatus.loading) {
              LoadingView().show(context: context);
            } else {
              LoadingView().hide();
            }
            if (scanState.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: scanState.message!,
              );
            }
          },
          child: credentialManifestState.filteredCredentialList.isEmpty
              ? const RequiredCredentialNotFound()
              : BasePage(
                  title: l10n.credentialShareTitle,
                  titleAlignment: Alignment.topCenter,
                  titleTrailing: const WhiteCloseButton(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  body: presentationDefinition == null
                      ? Container()
                      : Column(
                          children: <Widget>[
                            Text(
                              '${widget.inputDescriptorIndex + 1}/${presentationDefinition.inputDescriptors.length}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                presentationDefinition
                                        .inputDescriptors[
                                            widget.inputDescriptorIndex]
                                        .purpose ??
                                    l10n.credentialPickSelect,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(
                              credentialManifestState
                                  .filteredCredentialList.length,
                              (index) {
                                final credentialModel = credentialManifestState
                                    .filteredCredentialList[index];

                                return CredentialsListPageItem(
                                  credentialModel: credentialModel,
                                  selected: credentialManifestState.selected
                                      .contains(index),
                                  isDiscover: false,
                                  onTap: () {
                                    context
                                        .read<CredentialManifestPickCubit>()
                                        .toggle(
                                          index: index,
                                          inputDescriptor:
                                              presentationDefinition
                                                      .inputDescriptors[
                                                  widget.inputDescriptorIndex],
                                          isVcSdJWT: isVcSdJWT,
                                        );
                                  },
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isVcSdJWT)
                                  MyElevatedButton(
                                    onPressed: !credentialManifestState
                                            .isButtonEnabled
                                        ? null
                                        : () {
                                            final credentialToBePresented =
                                                credentialManifestState
                                                        .filteredCredentialList[
                                                    credentialManifestState
                                                        .selected.first];

                                            Navigator.of(context)
                                                .pushReplacement<void, void>(
                                              SelectiveDisclosurePickPage.route(
                                                uri: widget.uri,
                                                issuer: widget.issuer,
                                                credential: widget.credential,
                                                credentialToBePresented:
                                                    credentialToBePresented,
                                                presentationDefinition:
                                                    presentationDefinition,
                                              ),
                                            );
                                          },

                                    /// next button because we will now choose
                                    /// the claims we will present
                                    /// from the selected credential
                                    text: l10n.next,
                                  )
                                else
                                  Builder(
                                    builder: (context) {
                                      final inputDescriptor =
                                          presentationDefinition!
                                                  .inputDescriptors[
                                              widget.inputDescriptorIndex];

                                      final bool isOptional = inputDescriptor
                                              .constraints
                                              ?.fields
                                              ?.first
                                              .optional ??
                                          false;

                                      final bool isOngoingStep =
                                          widget.inputDescriptorIndex + 1 !=
                                              presentationDefinition
                                                  .inputDescriptors.length;

                                      if (isOptional) {
                                        return MyElevatedButton(
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
                                                  : l10n.credentialPickShare,
                                        );
                                      } else {
                                        return MyElevatedButton(
                                          onPressed: !credentialManifestState
                                                  .isButtonEnabled
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
                                              : l10n.credentialPickShare,
                                        );
                                      }
                                    },
                                  ),
                                const SizedBox(height: 8),
                                MyOutlinedButton(
                                  text: l10n.cancel,
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
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
        widget.credentialsToBePresented,
      );
    } else {
      final selectedCredentials = credentialManifestState.selected
          .map(
            (selectedIndex) =>
                credentialManifestState.filteredCredentialList[selectedIndex],
          )
          .toList();

      updatedCredentials = List.of(
        widget.credentialsToBePresented,
      )..addAll(selectedCredentials);
    }

    getLogger('present')
        .i('credential to presented - ${updatedCredentials.length}');

    if (widget.inputDescriptorIndex + 1 !=
        presentationDefinition.inputDescriptors.length) {
      await Navigator.of(context).pushReplacement<void, void>(
        CredentialManifestOfferPickPage.route(
          uri: widget.uri,
          credential: widget.credential,
          issuer: widget.issuer,
          inputDescriptorIndex: widget.inputDescriptorIndex + 1,
          credentialsToBePresented: updatedCredentials,
        ),
      );
    } else {
      final bool userPINCodeForAuthentication = context
          .read<ProfileCubit>()
          .state
          .model
          .profileSetting
          .walletSecurityOptions
          .secureSecurityAuthenticationWithPinCode;

      if (userPINCodeForAuthentication) {
        /// Authenticate
        bool authenticated = false;
        await securityCheck(
          context: context,
          title: context.l10n.typeYourPINCodeToShareTheData,
          localAuthApi: LocalAuthApi(),
          onSuccess: () {
            authenticated = true;
          },
        );

        if (!authenticated) {
          return;
        }
      }
      await context.read<ScanCubit>().credentialOfferOrPresent(
            uri: widget.uri,
            credentialModel: widget.credential,
            keyId: SecureStorageKeys.ssiKey,
            credentialsToBePresented: updatedCredentials,
            issuer: widget.issuer,
            qrCodeScanCubit: context.read<QRCodeScanCubit>(),
          );
    }
  }
}
