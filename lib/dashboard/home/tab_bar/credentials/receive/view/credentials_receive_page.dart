import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsReceivePage extends StatefulWidget {
  const CredentialsReceivePage({
    Key? key,
    required this.uri,
    required this.preview,
    required this.issuer,
  }) : super(key: key);

  final Uri uri;
  final Map<String, dynamic> preview;
  final Issuer issuer;

  static Route route({
    required Uri uri,
    required Map<String, dynamic> preview,
    required Issuer issuer,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => CredentialsReceivePage(
          uri: uri,
          preview: preview,
          issuer: issuer,
        ),
        settings: const RouteSettings(name: '/credentialsReceive'),
      );

  @override
  State<CredentialsReceivePage> createState() => _CredentialsReceivePageState();
}

class _CredentialsReceivePageState extends State<CredentialsReceivePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ScanCubit, ScanState>(
      listener: (BuildContext context, ScanState state) async {
        if (state.status == ScanStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }
      },
      builder: (context, state) {
        final credentialModel = CredentialModel.fromJson(widget.preview);
        final outputDescriptors =
            credentialModel.credentialManifest?.outputDescriptors;

        final textColor = Theme.of(context).colorScheme.valueColor;

        return BasePage(
          title: l10n.credentialReceiveTitle,
          useSafeArea: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Row(
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.all(24),
              //         child: Text(
              //           '${widget.uri.host} ${l10n.credentialReceiveHost}',
              //           maxLines: 3,
              //           textAlign: TextAlign.center,
              //          style: Theme.of(builderContext).textTheme.bodyText1,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16),
              CredentialDisplay(
                credentialModel: credentialModel,
                credDisplayType: CredDisplayType.Detail,
                fromCredentialOffer: true,
              ),
              if (outputDescriptors != null) ...[
                const SizedBox(height: 30),
                ExpansionTileContainer(
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(
                      l10n.credentialManifestDescription,
                      style:
                          Theme.of(context).textTheme.credentialManifestTitle2,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: DisplayDescriptionWidget(
                          displayMapping:
                              outputDescriptors.first.display?.description,
                          credentialModel: credentialModel,
                          textColor: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
          navigation: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyGradientButton(
                  text: l10n.credentialAddThisCard,
                  onPressed: () {
                    if (credentialModel
                            .credentialManifest?.presentationDefinition !=
                        null) {
                      Navigator.of(context).pushReplacement<void, void>(
                        CredentialManifestOfferPickPage.route(
                          uri: widget.uri,
                          credential: credentialModel,
                          issuer: widget.issuer,
                          inputDescriptorIndex: 0,
                          credentialsToBePresented: [],
                        ),
                      );
                    } else {
                      context.read<ScanCubit>().credentialOffer(
                            uri: widget.uri,
                            credentialModel: credentialModel,
                            keyId: SecureStorageKeys.ssiKey,
                            issuer: widget.issuer,
                          );
                    }
                  },
                ),
                const SizedBox(height: 8),
                MyOutlinedButton(
                  verticalSpacing: 20,
                  borderRadius: 20,
                  text: l10n.credentialReceiveCancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
