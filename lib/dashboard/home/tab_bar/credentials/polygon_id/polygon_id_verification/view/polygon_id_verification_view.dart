import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
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
    return BlocProvider(
      create: (context) => PolygonIdVerificationCubit(
        secureStorageProvider: getSecureStorage,
        polygonIdCubit: context.read<PolygonIdCubit>(),
      ),
      child: PolygonIdVerificationView(
        iden3MessageEntity: iden3MessageEntity,
      ),
    );
  }
}

class PolygonIdVerificationView extends StatefulWidget {
  const PolygonIdVerificationView({
    super.key,
    required this.iden3MessageEntity,
  });

  final Iden3MessageEntity iden3MessageEntity;

  @override
  State<PolygonIdVerificationView> createState() =>
      _PolygonIdVerificationViewState();
}

class _PolygonIdVerificationViewState extends State<PolygonIdVerificationView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<PolygonIdVerificationCubit>()
          .getCredentialStatus(widget.iden3MessageEntity);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final body = widget.iden3MessageEntity.body as AuthBodyRequest;
    // TODO(all): change UI
    return BlocConsumer<PolygonIdVerificationCubit, PolygonIdVerificationState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }
      },
      builder: (context, state) {
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

                      final proofTypeMsg =
                          getSignatureType(proofScopeRequest.circuitId);

                      final credentialSubject =
                          proofScopeRequest.query.credentialSubject;

                      String requirementValue = '';

                      if (credentialSubject != null) {
                        credentialSubject.forEach((reqKey, reqValue) {
                          requirementValue = '$requirementValue$reqKey \n';

                          (reqValue as Map<String, dynamic>).forEach(
                            (conditionKey, conditionValue) {
                              // handling key
                              String conditionMsg = '';
                              if (conditionKey == r'$eq') {
                                conditionMsg = 'is';
                              } else if (conditionKey == r'$lt') {
                                conditionMsg = 'is smaller than';
                              } else if (conditionKey == r'$gt') {
                                conditionMsg = 'is bigger than';
                              } else if (conditionKey == r'$in') {
                                conditionMsg =
                                    'is one of the following values:';
                              } else if (conditionKey == r'$nin') {
                                conditionMsg =
                                    'is not one of the following values:';
                              } else if (conditionKey == r'$ne') {
                                conditionMsg = 'is not';
                              }

                              //handling value
                              if (conditionValue is List) {
                                conditionMsg = '$conditionMsg\n';
                                for (final val in conditionValue) {
                                  conditionMsg = '$conditionMsg - $val';
                                  conditionMsg = '$conditionMsg\n';
                                }
                                conditionMsg = conditionMsg.substring(
                                  0,
                                  conditionMsg.length - 1,
                                );
                              } else {
                                conditionMsg = '$conditionMsg $conditionValue';
                              }

                              requirementValue =
                                  requirementValue + conditionMsg;
                            },
                          );
                        });
                      }

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                separateUppercaseWords(
                                  proofScopeRequest.query.type!,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                requirementValue,
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Allowed issuers: ${proofScopeRequest.query.allowedIssuers}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Proof type: - $proofTypeMsg',
                                textAlign: TextAlign.start,
                              ),
                              if (state.claimEntities!.isNotEmpty &&
                                  state.claimEntities![index] == null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Status: - ${l10n.credentialNotFound}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
                        onPressed: state.canGenerateProof
                            ? () {
                                Navigator.of(context)
                                    .pushReplacement<void, void>(
                                  PolygonIdProofPage.route(
                                    iden3MessageEntity:
                                        widget.iden3MessageEntity,
                                  ),
                                );
                              }
                            : null,
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
      },
    );
  }
}
