import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

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
    final l10n = context.l10n;
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
            if (body.scope != null)
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: body.scope!.length,
                itemBuilder: (context, index) {
                  final proofScopeRequest = body.scope![index];

                  var proofTypeMsg = '';
                  if (proofScopeRequest.circuitId ==
                          'credentialAtomicQuerySigV2' ||
                      proofScopeRequest.circuitId ==
                          'credentialAtomicQuerySigV2OnChain') {
                    proofTypeMsg = ' - BJJ Signature';
                  } else if (proofScopeRequest.circuitId ==
                          'credentialAtomicQueryMTPV2' ||
                      proofScopeRequest.circuitId ==
                          'credentialAtomicQueryMTPV2OnChain') {
                    proofTypeMsg = ' - SMT Signature';
                  }

                  return Column(
                    children: [
                      Text(
                        'Credential Type: ${proofScopeRequest.query.type}',
                        textAlign: TextAlign.center,
                      ),
                      // const SizedBox(height: 10),
                      // FutureBuilder<List<FilterEntity>>(
                      //   future: context
                      //       .read<PolygonIdCubit>()
                      //       .getFilters(message: iden3MessageEntity),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.data != null) {
                      //       final data = snapshot.data as List<FilterEntity>;
                      //       return ListView.builder(
                      //         shrinkWrap: true,
                      //         physics: const ScrollPhysics(),
                      //         itemCount: data.length,
                      //         itemBuilder: (context, i) {
                      //           return Text(
                      //             'Filter(${i + 1}): ${data[i].operator} ${data[i].name} ${data[i].value}',
                      //             textAlign: TextAlign.center,
                      //           );
                      //         },
                      //       );
                      //     }

                      //     return Container();
                      //   },
                      // ),
                      const SizedBox(height: 10),
                      Text(
                        'Requirements: ${proofScopeRequest.query.credentialSubject}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),

                      /// About allowed issuers, it will accept a list of dids
                      /// string of the issuers or an asterisk for any issuer
                      Text(
                        'Allowed issuers: ${proofScopeRequest.query.allowedIssuers}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Proof type: $proofTypeMsg',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
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
                    text: 'Accept',
                    onPressed: () async {
                      final mnemonic = await getSecureStorage
                          .get(SecureStorageKeys.ssiMnemonic);

                      final filteredClaims = await context
                          .read<PolygonIdCubit>()
                          .getFilteredClaims(
                            iden3MessageEntity: iden3MessageEntity,
                            mnemonic: mnemonic!,
                          );

                      if (filteredClaims.isEmpty) {
                        AlertMessage.showStateMessage(
                          context: context,
                          stateMessage: StateMessage(
                            stringMessage: l10n.claimNotFound,
                          ),
                        );
                        return;
                      }

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