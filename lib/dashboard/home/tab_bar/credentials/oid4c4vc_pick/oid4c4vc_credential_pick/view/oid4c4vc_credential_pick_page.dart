import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class Oidc4vcCredentialPickPage extends StatelessWidget {
  const Oidc4vcCredentialPickPage({
    super.key,
    required this.credentials,
    required this.userPin,
    required this.preAuthorizedCode,
    required this.issuer,
    required this.isEBSIV3,
    required this.credentialOfferJson,
    required this.openIdConfiguration,
  });

  final List<dynamic> credentials;
  final String? userPin;
  final String? preAuthorizedCode;
  final String issuer;
  final bool isEBSIV3;
  final dynamic credentialOfferJson;
  final OpenIdConfiguration openIdConfiguration;

  static Route<dynamic> route({
    required List<dynamic> credentials,
    required String? userPin,
    required String? preAuthorizedCode,
    required String issuer,
    required bool isEBSIV3,
    required dynamic credentialOfferJson,
    required OpenIdConfiguration openIdConfiguration,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => Oidc4vcCredentialPickPage(
          credentials: credentials,
          userPin: userPin,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
          isEBSIV3: isEBSIV3,
          credentialOfferJson: credentialOfferJson,
          openIdConfiguration: openIdConfiguration,
        ),
        settings: const RouteSettings(name: '/Oidc4vcCredentialPickPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Oidc4vcCredentialPickCubit(),
      child: Oidc4vcCredentialPickView(
        credentials: credentials,
        userPin: userPin,
        issuer: issuer,
        preAuthorizedCode: preAuthorizedCode,
        isEBSIV3: isEBSIV3,
        credentialOfferJson: credentialOfferJson,
        openIdConfiguration: openIdConfiguration,
      ),
    );
  }
}

class Oidc4vcCredentialPickView extends StatelessWidget {
  const Oidc4vcCredentialPickView({
    super.key,
    required this.credentials,
    required this.userPin,
    required this.preAuthorizedCode,
    required this.issuer,
    required this.isEBSIV3,
    required this.credentialOfferJson,
    required this.openIdConfiguration,
  });

  final List<dynamic> credentials;
  final String? userPin;
  final String? preAuthorizedCode;
  final String issuer;
  final bool isEBSIV3;
  final dynamic credentialOfferJson;
  final OpenIdConfiguration openIdConfiguration;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<QRCodeScanCubit, QRCodeScanState>(
      listener: (context, state) {
        if (state.status == QrScanStatus.goBack) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<Oidc4vcCredentialPickCubit, List<int>>(
        builder: (context, state) {
          return BasePage(
            title: l10n.credentialPickTitle,
            titleTrailing: const WhiteCloseButton(),
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            body: Column(
              children: <Widget>[
                ...List.generate(
                  credentials.length,
                  (index) {
                    final credential = getCredentialData(credentials[index]);

                    final CredentialSubjectType credentialSubjectType =
                        getCredTypeFromName(credential) ??
                            CredentialSubjectType.defaultCredential;

                    final vcFormatType = context
                        .read<ProfileCubit>()
                        .state
                        .model
                        .profileSetting
                        .selfSovereignIdentityOptions
                        .customOidc4vcProfile
                        .vcFormatType;

                    final DiscoverDummyCredential discoverDummyCredential =
                        credentialSubjectType.dummyCredential(vcFormatType);

                    Display? display;

                    // fetch for displaying the image
                    if (openIdConfiguration.credentialsSupported != null) {
                      final credentialsSupported =
                          openIdConfiguration.credentialsSupported!;
                      final CredentialsSupported? credSupported =
                          credentialsSupported.firstWhereOrNull(
                        (CredentialsSupported credentialsSupported) =>
                            credentialsSupported.id != null &&
                            credentialsSupported.id == credential,
                      );

                      if (credSupported != null &&
                          credSupported.display != null) {
                        display = credSupported.display!.firstWhereOrNull(
                          (Display display) =>
                              display.locale == 'en-US' ||
                              display.locale == 'en-GB',
                        );
                      }
                    }

                    return TransparentInkWell(
                      onTap: () => context
                          .read<Oidc4vcCredentialPickCubit>()
                          .updateList(index),
                      child: Column(
                        children: [
                          if (display != null)
                            CredentialDisplay(
                              credentialModel: CredentialModel(
                                id: '',
                                image: '',
                                credentialPreview: Credential.dummy(),
                                shareLink: '',
                                data: const <String, dynamic>{},
                                display: display,
                              ),
                              credDisplayType: CredDisplayType.List,
                              vcFormatType: vcFormatType,
                              displyalDescription: false,
                            )
                          else
                            DummyCredentialImage(
                              credentialSubjectType: credentialSubjectType,
                              image: discoverDummyCredential.image,
                              credentialName: credential,
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                state.contains(index)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 25,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            navigation: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: MyGradientButton(
                  onPressed: state.isEmpty
                      ? null
                      : () async {
                          if (state.isEmpty) return;

                          final selectedCredentials =
                              state.map((index) => credentials[index]).toList();

                          await context
                              .read<QRCodeScanCubit>()
                              .processSelectedCredentials(
                                selectedCredentials: selectedCredentials,
                                userPin: userPin,
                                issuer: issuer,
                                preAuthorizedCode: preAuthorizedCode,
                                isEBSIV3: isEBSIV3,
                                credentialOfferJson: credentialOfferJson,
                              );
                        },
                  text: l10n.proceed,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
