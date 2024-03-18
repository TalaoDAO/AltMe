import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/selective_disclosure/widget/display_selective_disclosure.dart';
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
      create: (context) => SelectiveDisclosureCubit(),
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
      child: BlocBuilder<SelectiveDisclosureCubit, SelectiveDisclosureState>(
        builder: (context, state) {
          return BasePage(
            title: l10n.thisOrganisationRequestsThisInformation,
            titleAlignment: Alignment.topCenter,
            titleTrailing: const WhiteCloseButton(),
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            body: DisplaySelectiveDisclosure(
              credentialModel: credentialToBePresented,
              claims: null,
              selectedIndex: state.selected,
              onPressed: (index) {
                context.read<SelectiveDisclosureCubit>().toggle(index);
              },
            ),
            navigation: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Tooltip(
                  message: l10n.credentialPickPresent,
                  child: MyGradientButton(
                    onPressed: state.selected.isEmpty
                        ? null
                        : () => present(
                              context: context,
                              selectedIndex: state.selected,
                              skip: false,
                            ),
                    text: l10n.credentialPickPresent,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> present({
    required BuildContext context,
    required List<int> selectedIndex,
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

    final encryptedValues = credentialToBePresented.jwt?.split('~');

    if (encryptedValues != null) {
      var newJwt = '${encryptedValues[0]}~';

      encryptedValues.removeAt(0);

      for (final index in selectedIndex) {
        newJwt = '$newJwt${encryptedValues[index]}~';
      }

      final CredentialModel newModel =
          credentialToBePresented.copyWith(selectiveDisclosureJwt: newJwt);

      final credToBePresented = [newModel];

      await context.read<ScanCubit>().credentialOfferOrPresent(
            uri: uri,
            credentialModel: credential,
            keyId: SecureStorageKeys.ssiKey,
            credentialsToBePresented: credToBePresented,
            issuer: issuer,
            qrCodeScanCubit: context.read<QRCodeScanCubit>(),
          );
    } else {
      throw Exception();
    }
  }
}
