import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/widgets/credential_widget/expansion_tile_title.dart';
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
      await context.read<WalletCubit>().deleteById(widget.credentialModel);
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
        return BasePage(
          title: l10n.cardDetails,
          titleLeading: BackLeadingButton(
            onPressed: () {
              if (context.read<CredentialDetailsCubit>().state.status !=
                  AppStatus.loading) {
                Navigator.of(context).pop();
              }
            },
          ),
          // titleTrailing: IconButton(
          //   onPressed: _edit,
          //   icon: const Icon(Icons.edit),
          // ),
          navigation: widget.credentialModel.shareLink != ''
              ? SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 5,
                    ),
                    height: kBottomNavigationBarHeight,
                    child: Tooltip(
                      message: l10n.credentialDetailShare,
                      child: MyElevatedButton.icon(
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
                      ),
                    ),
                  ),
                )
              : null,
          body: BackgroundCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DisplayDetail(
                  credentialModel: widget.credentialModel,
                  fromCredentialOffer: false,
                ),
                if (!isEbsiIssuer(widget.credentialModel)) ...[
                  const SizedBox(height: 30),
                  CredentialActiveStatus(
                    credentialStatus: state.credentialStatus,
                  ),
                ],
                if (outputDescriptors != null) ...[
                  const SizedBox(height: 30),
                  CredentialManifestDetails(
                    outputDescriptor: outputDescriptors.first,
                    credentialModel: widget.credentialModel,
                  ),
                ],
                if (outputDescriptors == null) const SizedBox(height: 30),
                ExpansionTileContainer(
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: ExpansionTileTitle(
                      title: l10n.credentialDetailsActivity,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.credentialModel.activities.length,
                          itemBuilder: (context, index) {
                            return ActivityWidget(
                              activity:
                                  widget.credentialModel.activities[index],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                MyOutlinedButton(
                  onPressed: delete,
                  text: l10n.credentialDetailDeleteCard,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
