import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid/polygonid.dart';

class PolygonIdCredentialOfferPage extends StatelessWidget {
  const PolygonIdCredentialOfferPage({
    super.key,
    required this.claims,
  });

  final List<ClaimEntity> claims;

  static Route<dynamic> route({
    required List<ClaimEntity> claims,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => PolygonIdCredentialOfferPage(
          claims: claims,
        ),
        settings: const RouteSettings(name: '/PolygonIdCredentialOffer'),
      );

  @override
  Widget build(BuildContext context) {
    // TODO(all): update UI
    final l10n = context.l10n;
    return BasePage(
      title: l10n.credentialReceiveTitle,
      useSafeArea: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Would you like to accept a credential from this organisation?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ListView.builder(
              itemCount: claims.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int i) {
                final jsonCredential = claims[i].info;
                final credentialPreview = Credential.fromJson(jsonCredential);

                return Center(
                  child: Text(
                    credentialPreview
                        .credentialSubjectModel.credentialSubjectType.name,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyGradientButton(
              text: 'Accept',
              onPressed: () {
                context.read<PolygonIdCubit>().addPolygonIdCredentials(
                      claims: claims,
                    );
              },
            ),
            const SizedBox(height: 8),
            MyOutlinedButton(
              verticalSpacing: 20,
              borderRadius: 20,
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
