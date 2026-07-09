import 'package:altme/app/app.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/widget/accept_oidc4_vp_transaction_page.dart';
import 'package:altme/oidc4vp_transaction/widget/attestation_list.dart';
import 'package:altme/oidc4vp_transaction/widget/navigation_buttons.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:flutter/material.dart';

class AcceptLocalDocumentSigningPage extends StatelessWidget {
  const AcceptLocalDocumentSigningPage({
    super.key,
    required this.trustedListEnabled,
    required this.trustedEntity,
    required this.uri,
    required this.showPrompt,
    required this.client,
  });

  final bool trustedListEnabled;
  final TrustedEntity? trustedEntity;
  final Uri uri;
  final bool showPrompt;
  final DioClient client;

  static Route<dynamic> route({
    required bool trustedListEnabled,
    required TrustedEntity? trustedEntity,
    required Uri uri,
    required bool showPrompt,
    required DioClient client,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AcceptLocalDocumentSigningPage'),
      builder: (_) => AcceptLocalDocumentSigningPage(
        trustedListEnabled: trustedListEnabled,
        trustedEntity: trustedEntity,
        uri: uri,
        showPrompt: showPrompt,
        client: client,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      navigation: const NavigationButtons(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: BackgroundCard(
                child: DisplayEntity(
                  trustedListEnabled: trustedListEnabled,
                  trustedEntity: trustedEntity,
                  notTrustedText: l10n.notTrustedEntity,
                  uri: uri,
                  client: client,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: BackgroundCard(
                child: Column(
                  children: [
                    Text(
                      'Local document signing request',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This request contains a local document signature requirement and will use a detached JWS payload.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AttestationList(uri: uri),
            ),
          ],
        ),
      ),
    );
  }
}
