import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/credential.dart';
import 'package:altme/home/tab_bar/credentials/pick/credential_manifest/credential_manifest_pick.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialManifestOfferPickPage extends StatelessWidget {
  const CredentialManifestOfferPickPage({
    Key? key,
    required this.uri,
    required this.credential,
  }) : super(key: key);

  final Uri uri;
  final CredentialModel credential;

  static Route route(Uri routeUri, CredentialModel credential) {
    return MaterialPageRoute<void>(
      builder: (context) => CredentialManifestOfferPickPage(
        uri: routeUri,
        credential: credential,
      ),
      settings: const RouteSettings(name: '/CredentialManifestOfferPickPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final presentationDefinition =
            credential.credentialManifest?.presentationDefinition;
        return CredentialManifestPickCubit(
          presentationDefinition: presentationDefinition == null
              ? <String, dynamic>{}
              : presentationDefinition.toJson(),
          credentialList: context.read<WalletCubit>().state.credentials,
        );
      },
      child: CredentialManifestOfferPickView(
        uri: uri,
        credential: credential,
      ),
    );
  }
}

class CredentialManifestOfferPickView extends StatelessWidget {
  const CredentialManifestOfferPickView({
    Key? key,
    required this.uri,
    required this.credential,
  }) : super(key: key);

  final Uri uri;
  final CredentialModel credential;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<CredentialManifestPickCubit,
            CredentialManifestPickState>(
          builder: (context, credentialManifestState) {
            final credentialCandidateList = List.generate(
              credentialManifestState.filteredCredentialList.length,
              (index) => CredentialsListPageItem(
                credentialModel:
                    credentialManifestState.filteredCredentialList[index],
                selected: credentialManifestState.selection.contains(index),
                onTap: () =>
                    context.read<CredentialManifestPickCubit>().toggle(index),
              ),
            );
            final _purpose = credential.credentialManifest
                ?.presentationDefinition?.inputDescriptors.first.purpose;
            return BlocListener<ScanCubit, ScanState>(
              listener: (context, scanState) {
                if (scanState.status == ScanStatus.loading) {
                  LoadingView().show(context: context);
                } else {
                  LoadingView().hide();
                }
              },
              child: BasePage(
                title: l10n.credentialPickTitle,
                titleTrailing: const WhiteCloseButton(),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                navigation: credentialCandidateList.isNotEmpty
                    ? SafeArea(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Tooltip(
                            message: l10n.credentialPickPresent,
                            child: Builder(
                              builder: (context) {
                                return MyGradientButton(
                                  onPressed: () async {
                                    if (credentialManifestState
                                        .selection.isEmpty) {
                                      AlertMessage.showStringMessage(
                                        context: context,
                                        message: l10n.credentialPickSelect,
                                        messageType: MessageType.error,
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

                                      final selectedCredentialsList =
                                          credentialManifestState.selection
                                              .map(
                                                (i) => credentialManifestState
                                                    .filteredCredentialList[i],
                                              )
                                              .toList();
                                      await context
                                          .read<ScanCubit>()
                                          .credentialOffer(
                                            url: uri.toString(),
                                            credentialModel: credential,
                                            keyId: SecureStorageKeys.ssiKey,
                                            signatureOwnershipProof:
                                                selectedCredentialsList.first,
                                          );
                                    }
                                  },
                                  text: l10n.credentialPickPresent,
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                body: Column(
                  children: <Widget>[
                    if (_purpose != null)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          _purpose,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (credentialCandidateList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          l10n.credentialSelectionListEmptyError,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      Text(
                        l10n.credentialPickSelect,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    const SizedBox(height: 12),
                    ...credentialCandidateList,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
