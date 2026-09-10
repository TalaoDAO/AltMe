import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/ldp_vc/ldp_vc.dart';
import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:altme/oidc4vc/widget/claim_list.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/selective_disclosure/widget/display_selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// "Add credential(s) to your wallet?" - shown once every offered
/// credential has been fetched (claims already known), letting the user
/// pick which of them to record, per ticket #3506.
class Oidc4vcCredentialPickPage extends StatelessWidget {
  const Oidc4vcCredentialPickPage({
    super.key,
    required this.items,
    required this.issuerName,
    required this.isTrusted,
    required this.uri,
    required this.oidc4vcParameters,
  });

  final List<CredentialAcceptanceItem> items;
  final String issuerName;
  final bool isTrusted;
  final Uri uri;
  final Oidc4vcParameters oidc4vcParameters;

  static Route<dynamic> route({
    required List<CredentialAcceptanceItem> items,
    required String issuerName,
    required bool isTrusted,
    required Uri uri,
    required Oidc4vcParameters oidc4vcParameters,
  }) => MaterialPageRoute<void>(
    builder: (context) => Oidc4vcCredentialPickPage(
      items: items,
      issuerName: issuerName,
      isTrusted: isTrusted,
      uri: uri,
      oidc4vcParameters: oidc4vcParameters,
    ),
    settings: const RouteSettings(name: '/Oidc4vcCredentialPickPage'),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Oidc4vcCredentialPickCubit(),
      child: Oidc4vcCredentialPickView(
        items: items,
        issuerName: issuerName,
        isTrusted: isTrusted,
        uri: uri,
        oidc4vcParameters: oidc4vcParameters,
      ),
    );
  }
}

class Oidc4vcCredentialPickView extends StatelessWidget {
  const Oidc4vcCredentialPickView({
    super.key,
    required this.items,
    required this.issuerName,
    required this.isTrusted,
    required this.uri,
    required this.oidc4vcParameters,
  });

  final List<CredentialAcceptanceItem> items;
  final String issuerName;
  final bool isTrusted;
  final Uri uri;
  final Oidc4vcParameters oidc4vcParameters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(l10n.issuedByLabel, style: textTheme.bodyMedium),
                Text(issuerName, style: textTheme.titleMedium),
                const SizedBox(height: 8),
                TrustBadge(
                  isTrusted: isTrusted,
                  trustedLabel: l10n.trustedIssuerLabel,
                  notTrustedLabel: l10n.issuerNotVerifiedLabel,
                  notTrustedDescription: isTrusted
                      ? null
                      : l10n.issuerNotVerifiedDescription,
                ),
                const SizedBox(height: 16),
                ...List.generate(items.length, (index) {
                  final item = items[index];
                  final credential = item.credentialModel;

                  final profileModel = context.read<ProfileCubit>().state.model;

                  final profileSetting = profileModel.profileSetting;

                  final credentialSupported = credential.credentialSupported;

                  final claims = credentialSupported?['claims'];
                  final containClaims = claims != null;

                  String? credentialImage;

                  if (containClaims) {
                    credentialImage = SelectiveDisclosure(
                      credential,
                    ).getPicture;
                  }

                  if (credential.format == 'ldp_vc') {
                    credentialImage = LdpVc(credential).getPicture;
                  }

                  return TransparentInkWell(
                    onTap: () => context
                        .read<Oidc4vcCredentialPickCubit>()
                        .updateList(index),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (credentialImage != null)
                            PictureDisplay(credentialImage: credentialImage)
                          else
                            CredentialDisplay(
                              credentialModel: credential,
                              credDisplayType: CredDisplayType.Detail,
                              profileSetting: profileSetting,
                              isDiscover: false,
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  state.contains(index)
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  size: 25,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          DisplaySelectiveDisclosure(
                            credentialModel: credential,
                            claims: null,
                            showVertically: true,
                          ),
                        ],
                      ),
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

                          final credentialsCubit = context
                              .read<CredentialsCubit>();
                          final lastSelected = state.reduce(
                            (a, b) => a > b ? a : b,
                          );

                          for (final index in state) {
                            await credentialsCubit.insertCredential(
                              credential: items[index].credentialModel,
                              showStatus: true,
                              showMessage: index == lastSelected,
                              uri: uri,
                            );
                          }

                          if (context.mounted) Navigator.of(context).pop();
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
