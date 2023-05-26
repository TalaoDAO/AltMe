import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/theme/theme.dart';
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
    final l10n = context.l10n;

    return BasePage(
      title: l10n.credentialReceiveTitle,
      useSafeArea: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TODO(all): change UI
            Text(
              'Would you like to accept this credential(s) from this organisation?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.credentialSubtitle,
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

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CredentialContainer(
                    child: AspectRatio(
                      aspectRatio: Sizes.credentialAspectRatio,
                      child: DecoratedBox(
                        decoration: BaseBoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .credentialBackground,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff0B67C5),
                              Color(0xff200072),
                            ],
                          ),
                          shapeColor:
                              Theme.of(context).colorScheme.documentShape,
                          value: 1,
                          anchors: const <Alignment>[],
                        ),
                        child: Center(
                          child: MyText(
                            separateUppercaseWords(
                              credentialPreview.credentialSubjectModel
                                  .credentialSubjectType.name,
                            ),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),
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
              text: l10n.accept,
              onPressed: () {
                Navigator.of(context).push<void>(
                  PinCodePage.route(
                    isValidCallback: () {
                      context.read<PolygonIdCubit>().addPolygonIdCredentials(
                            claims: claims,
                          );
                    },
                    restrictToBack: false,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            MyOutlinedButton(
              verticalSpacing: 20,
              borderRadius: 20,
              text: l10n.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
