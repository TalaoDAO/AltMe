import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

class PolygonIdProofPage extends StatelessWidget {
  const PolygonIdProofPage({
    super.key,
    required this.iden3MessageEntity,
  });

  final Iden3MessageEntity iden3MessageEntity;

  static Route<dynamic> route({
    required Iden3MessageEntity iden3MessageEntity,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => PolygonIdProofPage(
          iden3MessageEntity: iden3MessageEntity,
        ),
        settings: const RouteSettings(name: '/PolygonIdProofPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final body = iden3MessageEntity.body as AuthBodyRequest;
    // TODO(all): change UI
    return BasePage(
      title: l10n.cryptographicProof,
      useSafeArea: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.home),
            Text(
              'You will generate proof for this organisation',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            Text(
              'CRYPTOGRPAHIC PROOF',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            Text(
              'No private data is shared, only the proof of eligibility '
              'to access.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      navigation: body.scope != null
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyGradientButton(
                    text: 'Generate Proof',
                    onPressed: () async {
                      await Navigator.of(context).push<void>(
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
            )
          : null,
    );
  }
}
