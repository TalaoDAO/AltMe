import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/selective_disclosure/widget/display_selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

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
          final profileSetting =
              context.read<ProfileCubit>().state.model.profileSetting;

          final credentialImage =
              SelectiveDisclosure(credentialToBePresented).getPicture;

          return BasePage(
            title: l10n.thisOrganisationRequestsThisInformation,
            titleAlignment: Alignment.topCenter,
            titleTrailing: const WhiteCloseButton(),
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            body: Column(
              children: [
                if (credentialImage != null)
                  PictureDisplay(credentialImage: credentialImage)
                else
                  CredentialDisplay(
                    credentialModel: credentialToBePresented,
                    credDisplayType: CredDisplayType.List,
                    profileSetting: profileSetting,
                  ),
                const SizedBox(height: 20),
                DisplaySelectiveDisclosure(
                  credentialModel: credentialToBePresented,
                  claims: null,
                  selectedIndex: state.selected,
                  onPressed: (claimIndex, sdIndexInJWT) {
                    context.read<SelectiveDisclosureCubit>().toggle(claimIndex);
                    context
                        .read<SelectiveDisclosureCubit>()
                        .saveIndexOfSDJWT(sdIndexInJWT);
                  },
                  showVertically: false,
                ),
              ],
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
                              selectedSDIndexInJWT: state.selectedSDIndexInJWT,
                              uri: uri,
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
    required List<int> selectedSDIndexInJWT,
    required Uri uri,
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

    final encryptedValues = credentialToBePresented.jwt
        ?.split('~')
        .where((element) => element.isNotEmpty)
        .toList();

    if (encryptedValues != null) {
      var newJwt = '${encryptedValues[0]}~';

      encryptedValues.removeAt(0);

      for (final index in selectedSDIndexInJWT) {
        newJwt = '$newJwt${encryptedValues[index]}~';
      }

      // Key Binding JWT

      final profileCubit = context.read<ProfileCubit>();

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      final didKeyType = customOidc4vcProfile.defaultDid;

      final privateKey = await fetchPrivateKey(
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final tokenParameters = TokenParameters(
        privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
        did: '', // just added as it is required field
        mediaType: MediaType.selectiveDisclosure,
        clientType:
            ClientType.jwkThumbprint, // just added as it is required field
        proofHeaderType: customOidc4vcProfile.proofHeader,
        clientId: '', // just added as it is required field
      );

      final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      final sdHash = hash(newJwt);

      final nonce = uri.queryParameters['nonce'] ?? '';
      final clientId = uri.queryParameters['client_id'] ?? '';

      final payload = {
        'nonce': nonce,
        'aud': clientId,
        'iat': iat,
        'sd_hash': sdHash,
      };

      /// sign and get token
      final jwtToken = profileCubit.oidc4vc.generateToken(
        payload: payload,
        tokenParameters: tokenParameters,
        ignoreProofHeaderType: true,
      );

      newJwt = '$newJwt$jwtToken';

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
