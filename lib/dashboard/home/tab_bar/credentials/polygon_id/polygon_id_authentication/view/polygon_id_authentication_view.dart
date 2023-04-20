import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid/polygonid.dart';

class PolygonIdAuthenticationPage extends StatelessWidget {
  const PolygonIdAuthenticationPage({
    super.key,
    required this.iden3MessageEntity,
  });

  final Iden3MessageEntity iden3MessageEntity;

  static Route<dynamic> route({
    required Iden3MessageEntity iden3MessageEntity,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => PolygonIdAuthenticationPage(
          iden3MessageEntity: iden3MessageEntity,
        ),
        settings: const RouteSettings(name: '/PolygonIdAuthentication'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: ' Polygon Id Authenticate',
      useSafeArea: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Would you like to authenticate?',
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
