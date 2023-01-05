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

class CredentialsDetailsPage extends StatelessWidget {
  const CredentialsDetailsPage({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  static Route route(CredentialModel credentialModel) {
    return MaterialPageRoute<void>(
      builder: (context) =>
          CredentialsDetailsPage(credentialModel: credentialModel),
      settings: const RouteSettings(name: '/credentialsDetailsPages'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CredentialDetailsCubit>(
      create: (context) => CredentialDetailsCubit(
        walletCubit: context.read<WalletCubit>(),
        didKitProvider: DIDKitProvider(),
      ),
      child: CredentialsDetailsView(credentialModel: credentialModel),
    );
  }
}

class CredentialsDetailsView extends StatefulWidget {
  const CredentialsDetailsView({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  _CredentialsDetailsViewState createState() => _CredentialsDetailsViewState();
}

class _CredentialsDetailsViewState extends State<CredentialsDetailsView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
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

        final bool disAllowDelete = widget.credentialModel.credentialPreview
                    .credentialSubjectModel.credentialSubjectType ==
                CredentialSubjectType.deviceInfo ||
            widget.credentialModel.credentialPreview.credentialSubjectModel
                    .credentialCategory ==
                CredentialCategory.blockchainAccountsCards;

        return BasePage(
          title: l10n.cardDetails,
          titleAlignment: Alignment.topCenter,
          titleLeading: const BackLeadingButton(),
          // titleTrailing: IconButton(
          //   onPressed: _edit,
          //   icon: const Icon(Icons.edit),
          // ),
          navigation: SafeArea(
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
                                Expanded(
                                  child: CredentialDetailTabbar(
                                    isSelected:
                                        state.credentialDetailTabStatus ==
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
