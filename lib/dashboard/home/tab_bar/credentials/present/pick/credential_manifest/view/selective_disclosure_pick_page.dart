import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/selective_disclosure/widget/select_selective_disclosure.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectiveDisclosurePickPage extends StatelessWidget {
  const SelectiveDisclosurePickPage({
    super.key,
    required this.uri,
    required this.credential,
    required this.issuer,
    required this.credentialToBePresented,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final CredentialModel credentialToBePresented;

  static Route<dynamic> route({
    required Uri uri,
    required CredentialModel credential,
    required Issuer issuer,
    required CredentialModel credentialToBePresented,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => SelectiveDisclosurePickPage(
        uri: uri,
        credential: credential,
        issuer: issuer,
        credentialToBePresented: credentialToBePresented,
      ),
      settings: const RouteSettings(name: '/SelectiveDisclosurePickPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CredentialManifestPickCubit(
          credential: credential,
          credentialList: context.read<CredentialsCubit>().state.credentials,
          inputDescriptorIndex: 0,
        );
      },
      child: SelectiveDisclosurePickView(
        uri: uri,
        credential: credential,
        issuer: issuer,
        credentialToBePresented: credentialToBePresented,
      ),
    );
  }
}

class SelectiveDisclosurePickView extends StatelessWidget {
  const SelectiveDisclosurePickView({
    super.key,
    required this.uri,
    required this.credential,
    required this.issuer,
    required this.credentialToBePresented,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final CredentialModel credentialToBePresented;

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
                  title: l10n.thisOrganisationRequestsThisInformation,
                  titleAlignment: Alignment.topCenter,
                  titleTrailing: const WhiteCloseButton(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  body: SelectSelectiveDisclosure(
                    credentialModel: credentialToBePresented,
                    claims: null,
                  ),
                  navigation: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Tooltip(
                        message: l10n.credentialPickPresent,
                        child: MyGradientButton(
                          // onPressed: !credentialManifestState.isButtonEnabled
                          //     ? null
                          //     : () => present(
                          //           context: context,
                          //           credentialManifestState:
                          //               credentialManifestState,
                          //           presentationDefinition:
                          //               presentationDefinition,
                          //           skip: false,
                          //         ),
                          onPressed: () => present(
                            context: context,
                            credentialManifestState: credentialManifestState,
                            presentationDefinition: presentationDefinition,
                            skip: false,
                          ),
                          text: l10n.credentialPickPresent,
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> present({
    required BuildContext context,
    required CredentialManifestPickState credentialManifestState,
    PresentationDefinition? presentationDefinition,
    required bool skip,
  }) async {
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
        localAuthApi: LocalAuthApi(),
        onSuccess: () {
          authenticated = true;
        },
      );

      if (!authenticated) {
        return;
      }
    }
    await context.read<ScanCubit>().presentSdJwt(
          uri: uri,
          credentialModel: credential,
          keyId: SecureStorageKeys.ssiKey,
          disclosuresToBePresented: [credentialToBePresented.jwt!],
          issuer: issuer,
          qrCodeScanCubit: context.read<QRCodeScanCubit>(),
        );
  }
}
