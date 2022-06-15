import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/home/tab_bar/credentials/pick/credential_manifest/credential_manifest_pick.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsReceivePage extends StatefulWidget {
  const CredentialsReceivePage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  final Uri uri;
  final Map<String, dynamic> preview;

  static Route route({
    required Uri uri,
    required Map<String, dynamic> preview,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) =>
            CredentialsReceivePage(uri: uri, preview: preview),
        settings: const RouteSettings(name: '/credentialsReceive'),
      );

  @override
  State<CredentialsReceivePage> createState() => _CredentialsReceivePageState();
}

class _CredentialsReceivePageState extends State<CredentialsReceivePage> {
  OverlayEntry? _overlay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        if (context.read<ScanCubit>().state.status == ScanStatus.loading) {
          return false;
        }
        return true;
      },
      child: BasePage(
        padding: const EdgeInsets.all(24),
        title: l10n.credentialReceiveTitle,
        titleTrailing: IconButton(
          onPressed: () {
            if (context.read<ScanCubit>().state.status != ScanStatus.loading) {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.close),
        ),
        body: BlocConsumer<ScanCubit, ScanState>(
          listener: (BuildContext context, ScanState state) async {
            if (state.status == ScanStatus.loading) {
              _overlay = OverlayEntry(
                builder: (_) => const LoadingDialog(),
              );
              Overlay.of(context)!.insert(_overlay!);
            } else {
              if (_overlay != null) {
                _overlay!.remove();
                _overlay = null;
              }
            }
          },
          builder: (builderContext, state) {
            final credentialModel = CredentialModel.fromJson(widget.preview);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          '${widget.uri.host} ${l10n.credentialReceiveHost}',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: Theme.of(builderContext).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DisplayDetail(credentialModel: credentialModel),
                const SizedBox(height: 24),
                BaseButton.primary(
                  context: context,
                  onPressed: () async {
                    /// We removed dialog box which is asking for the user
                    /// to provide alias to the credential.
                    const alias = '';

                    if (credentialModel
                            .credentialManifest?.presentationDefinition !=
                        null) {
                      await Navigator.of(context).pushReplacement<void, void>(
                        CredentialManifestOfferPickPage.route(
                          widget.uri,
                          CredentialModel.copyWithAlias(
                            oldCredentialModel: credentialModel,
                            newAlias: alias,
                          ),
                        ),
                      );
                    } else {
                      await context.read<ScanCubit>().credentialOffer(
                            url: widget.uri.toString(),
                            credentialModel: CredentialModel.copyWithAlias(
                              oldCredentialModel: credentialModel,
                              newAlias: alias,
                            ),
                            keyId: 'key',
                          );
                    }
                  },
                  child: Text(l10n.credentialReceiveConfirm),
                ),
                const SizedBox(height: 8),
                BaseButton.transparent(
                  context: context,
                  onPressed: () => Navigator.of(builderContext).pop(),
                  child: Text(l10n.credentialReceiveCancel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
