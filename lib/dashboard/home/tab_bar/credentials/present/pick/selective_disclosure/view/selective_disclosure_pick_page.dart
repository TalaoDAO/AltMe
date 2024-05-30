import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/selective_disclosure/widget/inject_selective_disclosure_state.dart';
import 'package:credential_manifest/credential_manifest.dart';
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
    required this.presentationDefinition,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final CredentialModel credentialToBePresented;
  final PresentationDefinition? presentationDefinition;

  static Route<dynamic> route({
    required Uri uri,
    required CredentialModel credential,
    required Issuer issuer,
    required CredentialModel credentialToBePresented,
    required PresentationDefinition? presentationDefinition,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => SelectiveDisclosurePickPage(
        uri: uri,
        credential: credential,
        issuer: issuer,
        credentialToBePresented: credentialToBePresented,
        presentationDefinition: presentationDefinition,
      ),
      settings: const RouteSettings(name: '/SelectiveDisclosurePickPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectiveDisclosureCubit(
        oidc4vc: OIDC4VC(),
      ),
      child: SelectiveDisclosurePickView(
        uri: uri,
        credential: credential,
        issuer: issuer,
        credentialToBePresented: credentialToBePresented,
        presentationDefinition: presentationDefinition,
      ),
    );
  }
}

class SelectiveDisclosurePickView extends StatefulWidget {
  const SelectiveDisclosurePickView({
    super.key,
    required this.uri,
    required this.credential,
    required this.issuer,
    required this.credentialToBePresented,
    required this.presentationDefinition,
  });

  final Uri uri;
  final CredentialModel credential;
  final Issuer issuer;
  final CredentialModel credentialToBePresented;
  final PresentationDefinition? presentationDefinition;

  @override
  State<SelectiveDisclosurePickView> createState() =>
      _SelectiveDisclosurePickViewState();
}

class _SelectiveDisclosurePickViewState
    extends State<SelectiveDisclosurePickView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<SelectiveDisclosureCubit>().dataFromPresentation(
            credentialModel: widget.credentialToBePresented,
            presentationDefinition: widget.presentationDefinition,
          );
    });
  }

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
      child: Builder(
        builder: (BuildContext context) {
          final profileSetting =
              context.read<ProfileCubit>().state.model.profileSetting;

          final credentialImage =
              SelectiveDisclosure(widget.credentialToBePresented).getPicture;

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
                    credentialModel: widget.credentialToBePresented,
                    credDisplayType: CredDisplayType.List,
                    profileSetting: profileSetting,
                    isDiscover: false,
                  ),
                const SizedBox(height: 20),
                ConsumeSelectiveDisclosureCubit(
                  credentialModel: widget.credentialToBePresented,
                  onPressed: (claimKey, claimKeyId, threeDotValue) {
                    context.read<SelectiveDisclosureCubit>().disclosureAction(
                          claimsKey: claimKey,
                          credentialModel: widget.credentialToBePresented,
                          threeDotValue: threeDotValue,
                          claimKeyId: claimKeyId,
                        );
                  },
                  showVertically: true,
                ),
              ],
            ),
            navigation: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Tooltip(
                  message: l10n.credentialPickPresent,
                  child: BlocBuilder<SelectiveDisclosureCubit,
                      SelectiveDisclosureState>(
                    builder: (context, state) {
                      return MyGradientButton(
                        onPressed: () => present(
                          context: context,
                          selectedSDIndexInJWT: state.selectedSDIndexInJWT,
                          uri: widget.uri,
                        ),
                        text: l10n.credentialPickPresent,
                      );
                    },
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

    final selectiveDisclosure =
        SelectiveDisclosure(widget.credentialToBePresented);

    final encryptedValues = widget.credentialToBePresented.jwt
        ?.split('~')
        .where((element) => element.isNotEmpty)
        .toList();

    if (encryptedValues != null) {
      var newJwt = '${encryptedValues[0]}~';

      for (final index in selectedSDIndexInJWT) {
        newJwt = '$newJwt${encryptedValues[index + 1]}~';
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
            ClientType.p256JWKThumprint, // just added as it is required field
        proofHeaderType: customOidc4vcProfile.proofHeader,
        clientId: '', // just added as it is required field
      );

      final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      final sdHash = OIDC4VC().sh256Hash(newJwt);

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

      final CredentialModel newModel = widget.credentialToBePresented
          .copyWith(selectiveDisclosureJwt: newJwt);

      final credToBePresented = [newModel];

      await context.read<ScanCubit>().credentialOfferOrPresent(
            uri: uri,
            credentialModel: widget.credential,
            keyId: SecureStorageKeys.ssiKey,
            credentialsToBePresented: credToBePresented,
            issuer: widget.issuer,
            qrCodeScanCubit: context.read<QRCodeScanCubit>(),
          );
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Issue with the disclosure encryption of jwt.',
        },
      );
    }
  }
}
