import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueryByExamplePresentPage extends StatefulWidget {
  const QueryByExamplePresentPage({
    super.key,
    required this.uri,
    required this.preview,
    required this.issuer,
  });

  final Uri uri;
  final Map<String, dynamic> preview;
  final Issuer issuer;

  static Route<dynamic> route({
    required Uri uri,
    required Map<String, dynamic> preview,
    required Issuer issuer,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => QueryByExamplePresentPage(
        uri: uri,
        preview: preview,
        issuer: issuer,
      ),
      settings: const RouteSettings(name: '/QueryByExamplePresent'),
    );
  }

  @override
  _QueryByExamplePresentPageState createState() =>
      _QueryByExamplePresentPageState();
}

class _QueryByExamplePresentPageState extends State<QueryByExamplePresentPage> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '''${l10n.credentialPresentRequiredCredential} credential(s).''',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              // const SizedBox(height: 16.0),
              // DocumentWidget(
              //     model: DocumentWidgetModel.fromCredentialModel(
              //         CredentialModel(
              //             id: '', image: '', data: {'issuer': ''}))),
              const SizedBox(height: 24),
              MyGradientButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement<void, void>(
                    QueryByExampleCredentialPickPage.route(
                      uri: widget.uri,
                      preview: widget.preview,
                      issuer: widget.issuer,
                      credentialQueryIndex: 0,
                      credentialsToBePresented: [],
                    ),
                  );
                },
                text: l10n.credentialPresentConfirm,
              ),
              const SizedBox(height: 8),
              MyOutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: l10n.credentialPresentCancel,
              ),
            ],
          );
        },
      ),
    );
  }
}
