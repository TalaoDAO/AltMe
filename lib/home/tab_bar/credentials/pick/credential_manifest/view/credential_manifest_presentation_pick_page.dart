import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/pick/credential_manifest/credential_manifest_pick.dart';
import 'package:altme/home/tab_bar/credentials/widgets/list_item.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialManifestPickPage extends StatefulWidget {
  const CredentialManifestPickPage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  final Uri uri;
  final Map<String, dynamic> preview;

  static Route route(Uri routeUri, Map<String, dynamic> preview) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => CredentialManifestPickCubit(
          presentationDefinition: preview['credential_manifest']
              ['presentation_definition'] as Map<String, dynamic>,
          credentialList: context.read<WalletCubit>().state.credentials,
        ),
        child: CredentialManifestPickPage(uri: routeUri, preview: preview),
      ),
      settings: const RouteSettings(name: '/CredentialManifestPickPage'),
    );
  }

  @override
  _CredentialManifestPickPageState createState() =>
      _CredentialManifestPickPageState();
}

class _CredentialManifestPickPageState
    extends State<CredentialManifestPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CredentialManifestPickCubit,
        CredentialManifestPickState>(
      builder: (context, state) {
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
          navigation: SafeArea(
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
                          final scanCubit = context.read<ScanCubit>();
                          scanCubit.verifiablePresentationRequest(
                            url: widget.uri.toString(),
                            keyId: SecureStorageKeys.key,
                            credentials: state.selection
                                .map((i) => state.filteredCredentialList[i])
                                .toList(),
                            challenge: widget.preview['challenge'] as String,
                            domain: widget.preview['domain'] as String,
                          );
                        }
                      },
                      child: Text(l10n.credentialPickPresent),
                    );
                  },
                ),
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Text(
                l10n.credentialPickSelect,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 12),
              ...List.generate(
                state.filteredCredentialList.length,
                (index) => CredentialsListPageItem(
                  credentialModel: state.filteredCredentialList[index],
                  selected: state.selection.contains(index),
                  onTap: () =>
                      context.read<CredentialManifestPickCubit>().toggle(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
