import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsPresentPage extends StatefulWidget {
  const CredentialsPresentPage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  final Uri uri;
  final Map<String, dynamic> preview;

  static Route route({
    required Uri uri,
    required Map<String, dynamic> preview,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => CredentialsPresentPage(uri: uri, preview: preview),
      settings: const RouteSettings(name: '/credentialsPresent'),
    );
  }

  @override
  _CredentialsPresentPageState createState() => _CredentialsPresentPageState();
}

class _CredentialsPresentPageState extends State<CredentialsPresentPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      padding: const EdgeInsets.all(16),
      title: l10n.credentialPresentTitle,
      titleTrailing: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close),
      ),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.175,
                    height: MediaQuery.of(context).size.width * 0.175,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.profileDummy,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '''${l10n.credentialPresentRequiredCredential} credential(s).''',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 16.0),
              // DocumentWidget(
              //     model: DocumentWidgetModel.fromCredentialModel(
              //         CredentialModel(
              //             id: '', image: '', data: {'issuer': ''}))),
              const SizedBox(height: 24),
              BaseButton.transparent(
                context: context,
                onPressed: () =>
                    Navigator.of(context).pushReplacement<void, void>(
                  QueryByExampleCredentialPickPage.route(
                    widget.uri,
                    widget.preview,
                  ),
                ),
                child: Text(l10n.credentialPresentConfirm),
              ),
              const SizedBox(height: 8),
              BaseButton.primary(
                context: context,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(l10n.credentialPresentCancel),
              ),
            ],
          );
        },
      ),
    );
  }
}
