import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class CredentialsDetailsPage extends StatelessWidget {
  const CredentialsDetailsPage({
    super.key,
    required this.credentialModel,
    required this.readOnly,
  });

  final CredentialModel credentialModel;
  final bool readOnly;

  static Route<dynamic> route({
    required CredentialModel credentialModel,
    bool readOnly = false,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => CredentialsDetailsPage(
        credentialModel: credentialModel,
        readOnly: readOnly,
      ),
      settings: const RouteSettings(name: '/credentialsDetailsPages'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CredentialDetailsCubit>(
      create: (context) => CredentialDetailsCubit(
        didKitProvider: DIDKitProvider(),
      ),
      child: CredentialsDetailsView(
        credentialModel: credentialModel,
        readOnly: readOnly,
      ),
    );
  }
}

class CredentialsDetailsView extends StatefulWidget {
  const CredentialsDetailsView({
    super.key,
    required this.credentialModel,
    required this.readOnly,
  });

  final CredentialModel credentialModel;
  final bool readOnly;

  @override
  _CredentialsDetailsViewState createState() => _CredentialsDetailsViewState();
}

class _CredentialsDetailsViewState extends State<CredentialsDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<CredentialDetailsCubit>()
          .verifyCredential(widget.credentialModel);
    });
  }

  Future<void> delete() async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              title: l10n.credentialDetailDeleteConfirmationDialog,
              yes: l10n.credentialDetailDeleteConfirmationDialogYes,
              no: l10n.credentialDetailDeleteConfirmationDialogNo,
            );
          },
        ) ??
        false;

    if (confirm) {
      final walletCubit = context.read<WalletCubit>();
      await walletCubit.deleteById(credential: widget.credentialModel);
      await context.read<CredentialListCubit>().initialise(walletCubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final outputDescriptors =
        widget.credentialModel.credentialManifest?.outputDescriptors;
    return BlocConsumer<CredentialDetailsCubit, CredentialDetailsState>(
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
        final List<Activity> activities =
            List<Activity>.from(widget.credentialModel.activities);

        final List<Activity> reversedList =
            List<Activity>.from(activities.reversed);

        if (activities.isNotEmpty) {
          reversedList.insert(0, activities[0]);
          reversedList.removeLast();
        }

        final bool isLinkeInCard = widget.credentialModel.credentialPreview
                .credentialSubjectModel.credentialSubjectType ==
            CredentialSubjectType.linkedInCard;

        final bool disAllowDelete = widget.credentialModel.credentialPreview
                    .credentialSubjectModel.credentialSubjectType ==
                CredentialSubjectType.walletCredential ||
            widget.credentialModel.credentialPreview.credentialSubjectModel
                    .credentialCategory ==
                CredentialCategory.blockchainAccountsCards;

        return BasePage(
          title: widget.readOnly ? l10n.linkedInProfile : l10n.cardDetails,
          titleAlignment: Alignment.topCenter,
          titleLeading: const BackLeadingButton(),
          // titleTrailing: IconButton(
          //   onPressed: () {
          //     Navigator.of(context)
          //         .push<void>(CredentialQrPage.route(widget.credentialModel));
          //   },
          //   icon: Icon(
          //     Icons.qr_code,
          //     color: Theme.of(context).colorScheme.onBackground,
          //   ),
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          navigation: widget.readOnly
              ? null
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyOutlinedButton(
                          onPressed: disAllowDelete ? null : delete,
                          text: l10n.credentialDetailDeleteCard,
                        ),
                        const SizedBox(height: 8),
                        MyOutlinedButton(
                          text: isLinkeInCard
                              ? l10n.exportToLinkedIn
                              : l10n.share,
                          onPressed: () {
                            if (isLinkeInCard) {
                              Navigator.of(context).push<void>(
                                GetLinkedinInfoPage.route(
                                  credentialModel: widget.credentialModel,
                                ),
                              );
                            } else {
                              final box =
                                  context.findRenderObject() as RenderBox?;
                              final subject = l10n.shareWith;

                              Share.share(
                                jsonEncode(widget.credentialModel.data),
                                subject: subject,
                                sharePositionOrigin:
                                    box!.localToGlobal(Offset.zero) & box.size,
                              );
                            }
                          },
                        ),
                        if (widget.credentialModel.shareLink != '')
                          MyOutlinedButton.icon(
                            icon: SvgPicture.asset(
                              IconStrings.qrCode,
                              width: 24,
                              height: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () {
                              Navigator.of(context).push<void>(
                                QrCodeDisplayPage.route(
                                  widget.credentialModel.id,
                                  widget.credentialModel,
                                ),
                              );
                            },
                            text: l10n.credentialDetailShare,
                          )
                        else
                          Container(),
                      ],
                    ),
                  ),
                ),
          scrollView: false,
          body: Column(
            children: [
              Expanded(
                child: BackgroundCard(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CredentialDisplay(
                          credentialModel: widget.credentialModel,
                          credDisplayType: CredDisplayType.Detail,
                          fromCredentialOffer: false,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CredentialDetailTabbar(
                                    isSelected: state
                                            .credentialDetailTabStatus ==
                                        CredentialDetailTabStatus.informations,
                                    title: l10n.credentialManifestInformations,
                                    onTap: () => context
                                        .read<CredentialDetailsCubit>()
                                        .changeTabStatus(
                                          CredentialDetailTabStatus
                                              .informations,
                                        ),
                                  ),
                                ),
                                if (!widget.readOnly)
                                  Expanded(
                                    child: CredentialDetailTabbar(
                                      isSelected: state
                                              .credentialDetailTabStatus ==
                                          CredentialDetailTabStatus.activity,
                                      title: l10n.credentialDetailsActivity,
                                      onTap: () => context
                                          .read<CredentialDetailsCubit>()
                                          .changeTabStatus(
                                            CredentialDetailTabStatus.activity,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            Divider(
                              height: 0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (state.credentialDetailTabStatus ==
                            CredentialDetailTabStatus.informations) ...[
                          if (!isEbsiIssuer(widget.credentialModel)) ...[
                            const SizedBox(height: 10),
                            CredentialActiveStatus(
                              credentialStatus: state.credentialStatus,
                            ),
                          ],
                          if (outputDescriptors != null) ...[
                            const SizedBox(height: 10),
                            CredentialManifestDetails(
                              outputDescriptor: outputDescriptors.first,
                              credentialModel: widget.credentialModel,
                            ),
                          ],
                        ],
                        if (state.credentialDetailTabStatus ==
                            CredentialDetailTabStatus.activity) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: reversedList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ActivityWidget(
                                activity: reversedList[index],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
