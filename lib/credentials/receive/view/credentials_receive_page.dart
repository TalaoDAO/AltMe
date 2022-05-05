import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsReceivePage extends StatelessWidget {
  const CredentialsReceivePage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final Uri url;

  static Route route(Uri routeUrl) => MaterialPageRoute<void>(
        builder: (context) => CredentialsReceivePage(url: routeUrl),
        settings: const RouteSettings(name: '/credentialsReceive'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      padding: const EdgeInsets.all(24),
      title: l10n.credentialReceiveTitle,
      titleTrailing: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close),
      ),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (builderContext, state) {
          if (state is ScanStatePreview) {
            final credential = CredentialModel.fromJson(state.preview!);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          '${url.host} ${l10n.credentialReceiveHost}',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: Theme.of(builderContext).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DocumentWidget(model: credential),
                const SizedBox(height: 24),
                BaseButton.primary(
                  context: context,
                  onPressed: () async {
                    final alias = await showDialog<String>(
                      context: builderContext,
                      builder: (context) => TextFieldDialog(
                        title: l10n.credentialPickAlertMessage,
                      ),
                    );
                    await context.read<ScanCubit>().credentialOffer(
                          url: url.toString(),
                          credentialModel: CredentialModel.copyWithAlias(
                            oldCredentialModel: credential,
                            newAlias: alias,
                          ),
                          keyId: 'key',
                        );
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
          }

          return const LinearProgressIndicator();
        },
      ),
    );
  }
}
