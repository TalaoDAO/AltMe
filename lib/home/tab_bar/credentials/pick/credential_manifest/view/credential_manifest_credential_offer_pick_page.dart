import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/credential.dart';
import 'package:altme/home/tab_bar/credentials/pick/credential_manifest/credential_manifest_pick.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialManifestOfferPickPage extends StatefulWidget {
  const CredentialManifestOfferPickPage({
    Key? key,
    required this.uri,
    required this.credential,
  }) : super(key: key);

  final Uri uri;
  final CredentialModel credential;

  static Route route(Uri routeUri, CredentialModel credential) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) {
          final presentationDefinition =
              credential.credentialManifest?.presentationDefinition;
          if (presentationDefinition != null) {
            return CredentialManifestPickCubit(
              presentationDefinition: presentationDefinition.toJson(),
              credentialList: context.read<WalletCubit>().state.credentials,
            );
          }
          return CredentialManifestPickCubit(
            presentationDefinition: <String, dynamic>{},
            credentialList: context.read<WalletCubit>().state.credentials,
          );
        },
        child: CredentialManifestOfferPickPage(
          uri: routeUri,
          credential: credential,
        ),
      ),
      settings: const RouteSettings(name: '/CredentialManifestPickPage'),
    );
  }

  @override
  _CredentialManifestOfferPickPageState createState() =>
      _CredentialManifestOfferPickPageState();
}

class _CredentialManifestOfferPickPageState
    extends State<CredentialManifestOfferPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<CredentialManifestPickCubit,
            CredentialManifestPickState>(
          builder: (context, state) {
            final credentialCandidateList = List.generate(
              state.filteredCredentialList.length,
              (index) => CredentialsListPageItem(
                credentialModel: state.filteredCredentialList[index],
                selected: state.selection.contains(index),
                onTap: () =>
                    context.read<CredentialManifestPickCubit>().toggle(index),
              ),
            );
            final _purpose = widget.credential.credentialManifest
                ?.presentationDefinition?.inputDescriptors.first.purpose;
            return BasePage(
              title: l10n.credentialPickTitle,
              titleTrailing: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 16,
              ),
              navigation: credentialCandidateList.isNotEmpty
                  ? SafeArea(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        height: kBottomNavigationBarHeight + 16,
                        child: Tooltip(
                          message: l10n.credentialPickPresent,
                          child: Builder(
                            builder: (context) {
                              return BaseButton.primary(
                                context: context,
                                onPressed: () {
                                  if (state.selection.isEmpty) {
                                    AlertMessage.showStringMessage(
                                      context: context,
                                      message: l10n.credentialPickSelect,
                                      messageType: MessageType.error,
                                    );
                                  } else {
                                    final selectedCredentialsList = state
                                        .selection
                                        .map(
                                          (i) =>
                                              state.filteredCredentialList[i],
                                        )
                                        .toList();
                                    context.read<ScanCubit>().credentialOffer(
                                          url: widget.uri.toString(),
                                          credentialModel: widget.credential,
                                          keyId: 'key',
                                          signatureOwnershipProof:
                                              selectedCredentialsList.first,
                                        );
                                  }
                                },
                                child: Text(l10n.credentialPickPresent),
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
            );
          },
        );
      },
    );
  }
}
