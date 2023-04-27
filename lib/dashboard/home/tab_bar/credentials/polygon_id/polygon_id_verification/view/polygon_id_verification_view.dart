import 'package:altme/app/app.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid/polygonid.dart';

class PolygonIdVerificationPage extends StatelessWidget {
  const PolygonIdVerificationPage({
    super.key,
    required this.iden3MessageEntity,
  });

  final Iden3MessageEntity iden3MessageEntity;

  static Route<dynamic> route({
    required Iden3MessageEntity iden3MessageEntity,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => PolygonIdVerificationPage(
          iden3MessageEntity: iden3MessageEntity,
        ),
        settings: const RouteSettings(name: '/PolygonIdVerification'),
      );

  @override
  Widget build(BuildContext context) {
    final body = iden3MessageEntity.body as AuthBodyRequest;
    // TODO(all): change UI
    return BasePage(
      title: 'Proof Request',
      useSafeArea: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This organisation requests a valid proof of this claim to vote '
              'for ${body.reason}:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Credential Type: ${body.scope![0].query.type}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Requirements: ${body.scope![0].query.credentialSubject}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Allowed issuers: ${body.scope![0].query.allowedIssuers}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Proof type: ${body.scope![0].circuitId}',
              textAlign: TextAlign.center,
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
                Navigator.of(context).push<void>(
                  PinCodePage.route(
                    isValidCallback: () {
                      context
                          .read<PolygonIdCubit>()
                          .authenticate(iden3MessageEntity);
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
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
