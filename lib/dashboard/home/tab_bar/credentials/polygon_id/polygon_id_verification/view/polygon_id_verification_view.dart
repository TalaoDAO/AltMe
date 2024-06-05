import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/theme/theme.dart';
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
                  l10n.thisOrganisationRequestsThisInformation,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.credentialSubtitle.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                ),
                const SizedBox(height: 10),
                if (body.scope != null)
                  ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: body.scope!.length,
                    itemBuilder: (context, index) {
                      final proofScopeRequest = body.scope![index];

                      // final proofTypeMsg =
                      //     getSignatureType(proofScopeRequest.circuitId);

                      final credentialSubject =
                          proofScopeRequest.query.credentialSubject;

                      String requirementValue = '';

                      if (credentialSubject != null) {
                        credentialSubject.forEach((reqKey, reqValue) {
                          requirementValue = '$requirementValue$reqKey ';

                          (reqValue as Map<String, dynamic>).forEach(
                            (conditionKey, conditionValue) {
                              // handling key
                              String conditionMsg = '';
                              if (conditionKey == r'$eq') {
                                conditionMsg = l10n.iS;
                              } else if (conditionKey == r'$lt') {
                                conditionMsg = l10n.isSmallerThan;
                              } else if (conditionKey == r'$gt') {
                                conditionMsg = l10n.isBiggerThan;
                              } else if (conditionKey == r'$in') {
                                conditionMsg = l10n.isOneOfTheFollowingValues;
                              } else if (conditionKey == r'$nin') {
                                conditionMsg =
                                    l10n.isNotOneOfTheFollowingValues;
                              } else if (conditionKey == r'$ne') {
                                conditionMsg = l10n.isNot;
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

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.proof,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  requirementValue,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: const Color(0xffD1CCE3)),
                                ),
                                const SizedBox(height: 10),
                                Divider(color: Colors.grey.withOpacity(0.25)),
                                if (state.claimEntities!.isNotEmpty &&
                                    state.claimEntities![index] == null) ...[
                                  const SizedBox(height: 5),
                                  Text(
                                    l10n.credentialNotFound,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red,
                                        ),
                                  ),
                                ] else ...[
                                  TransparentInkWell(
                                    onTap: () {
                                      Navigator.of(context).push<void>(
                                        PolygonIdProofPage.route(
                                          claimEntity:
                                              state.claimEntities![index]!,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${l10n.from} ${splitUppercase(
                                                proofScopeRequest.query.type!,
                                              )}',
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.chevron_right,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
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
                        text: l10n.approve,
                        onPressed: state.canGenerateProof
                            ? () async {
                                await securityCheck(
                                  context: context,
                                  localAuthApi: LocalAuthApi(),
                                  onSuccess: () {
                                    context
                                        .read<PolygonIdCubit>()
                                        .authenticateOrGenerateProof(
                                          iden3MessageEntity:
                                              widget.iden3MessageEntity,
                                          isGenerateProof: true,
                                        );
                                  },
                                );
                              }
                            : null,
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
                )
              : null,
        );
      },
    );
  }
}
