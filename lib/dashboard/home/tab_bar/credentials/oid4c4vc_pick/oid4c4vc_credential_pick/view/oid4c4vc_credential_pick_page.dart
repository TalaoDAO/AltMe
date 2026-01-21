import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class Oidc4vcCredentialPickPage extends StatelessWidget {
  const Oidc4vcCredentialPickPage({
    super.key,
    required this.credentials,
    required this.userPin,
    required this.txCode,
    required this.oidc4vcParameters,
  });

  final List<dynamic> credentials;
  final String? userPin;
  final String? txCode;
  final Oidc4vcParameters oidc4vcParameters;

  static Route<dynamic> route({
    required List<dynamic> credentials,
    required String? userPin,
    required String? txCode,
    required Oidc4vcParameters oidc4vcParameters,
  }) => MaterialPageRoute<void>(
    builder: (context) => Oidc4vcCredentialPickPage(
      credentials: credentials,
      userPin: userPin,
      txCode: txCode,
      oidc4vcParameters: oidc4vcParameters,
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
        txCode: txCode,
        oidc4vcParameters: oidc4vcParameters,
      ),
    );
  }
}

class Oidc4vcCredentialPickView extends StatelessWidget {
  const Oidc4vcCredentialPickView({
    super.key,
    required this.credentials,
    required this.userPin,
    required this.txCode,
    required this.oidc4vcParameters,
  });

  final List<dynamic> credentials;
  final String? userPin;
  final String? txCode;
  final Oidc4vcParameters oidc4vcParameters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languageCode = context.read<LangCubit>().state.locale.languageCode;

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
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            body: Column(
              children: <Widget>[
                ...List.generate(credentials.length, (index) {
                  final credential = getCredentialData(credentials[index]);

                  final CredentialSubjectType credentialSubjectType =
                      getCredTypeFromName(credential) ??
                      CredentialSubjectType.defaultCredential;

                  final profileModel = context.read<ProfileCubit>().state.model;

                  final profileSetting = profileModel.profileSetting;
                  final formatType = profileSetting
                      .selfSovereignIdentityOptions
                      .customOidc4vcProfile
                      .vcFormatType;

                  final DiscoverDummyCredential discoverDummyCredential =
                      credentialSubjectType.dummyCredential(
                        profileSetting: profileSetting,
                        assignedVCFormatType: formatType,
                      );

                  // fetch for displaying the image
                  final (Display? display, _) = fetchDisplay(
                    openIdConfiguration:
                        oidc4vcParameters.issuerOpenIdConfiguration,
                    credentialType: credential,
                    languageCode: languageCode,
                  );

                  return TransparentInkWell(
                    onTap: () => context
                        .read<Oidc4vcCredentialPickCubit>()
                        .updateList(index),
                    child: Column(
                      children: [
                        if (credentialSubjectType ==
                                CredentialSubjectType.defaultCredential &&
                            display != null)
                          CredentialDisplay(
                            credentialModel: CredentialModel(
                              id: '',
                              image: '',
                              credentialPreview: Credential.dummy(),
                              shareLink: '',
                              data: const <String, dynamic>{},
                              display: display,
                              profileLinkedId: profileModel.profileType.getVCId,
                            ),
                            credDisplayType: CredDisplayType.List,
                            profileSetting: profileSetting,
                            displyalDescription: true,
                            isDiscover: false,
                          )
                        else
                          DummyCredentialImage(
                            credentialSubjectType: credentialSubjectType,
                            image: discoverDummyCredential.image,
                            credentialName: credential,
                            displayExternalIssuer: display,
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
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            navigation: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: MyElevatedButton(
                  onPressed: state.isEmpty
                      ? null
                      : () async {
                          if (state.isEmpty) return;

                          final selectedCredentials = state
                              .map((index) => credentials[index])
                              .toList();

                          await context
                              .read<QRCodeScanCubit>()
                              .processSelectedCredentials(
                                selectedCredentials: selectedCredentials,
                                userPin: userPin,
                                txCode: txCode,
                                oidc4vcParameters: oidc4vcParameters,
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
