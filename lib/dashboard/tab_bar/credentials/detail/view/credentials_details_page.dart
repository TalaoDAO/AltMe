import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

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
  final logger = Logger('altme-wallet/credentials/detail');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final l10n = context.l10n;
      String title = widget.credentialModel.alias!;
      if (title == '') {
        title = l10n.cardDetails;
      }
      context.read<CredentialDetailsCubit>().setTitle(title);
      context.read<CredentialDetailsCubit>().verify(widget.credentialModel);
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

  Future<void> _edit() async {
    final l10n = context.l10n;
    logger.info('Start edit flow');
    final credentialDetailsCubit = context.read<CredentialDetailsCubit>();
    final newAlias = await showDialog<String>(
      context: context,
      builder: (_) => TextFieldDialog(
        label: l10n.credentialAlias,
        title: l10n.credentialDetailEditConfirmationDialog,
        initialValue: credentialDetailsCubit.state.title,
        yes: l10n.credentialDetailEditConfirmationDialogYes,
        no: l10n.credentialDetailEditConfirmationDialogNo,
      ),
    );

    logger.info('Edit flow answered with: $newAlias');

    if (newAlias != null && newAlias != credentialDetailsCubit.state.title) {
      logger.info('New alias is different, going to update credential');
      await credentialDetailsCubit.update(widget.credentialModel, newAlias);
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
          title: state.title ?? l10n.credential,
          titleTag:
              'credential/${state.title ?? widget.credentialModel.id}/issuer',
          titleLeading: BackLeadingButton(
            onPressed: () {
              if (context.read<CredentialDetailsCubit>().state.status !=
                  AppStatus.loading) {
                Navigator.of(context).pop();
              }
            },
          ),
          titleTrailing: IconButton(
            onPressed: _edit,
            icon: const Icon(Icons.edit),
          ),
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
                      child: BaseButton.primary(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).push<void>(
                            QrCodeDisplayPage.route(
                              widget.credentialModel.id,
                              widget.credentialModel,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              IconStrings.qrCode,
                              width: 24,
                              height: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 16),
                            Text(l10n.credentialDetailShare),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          body: BackgroundCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DisplayDetail(credentialModel: widget.credentialModel),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                state.verificationState.icon,
                                color: state.verificationState.color,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                state.verificationState.message(context),
                                style:
                                    Theme.of(context).textTheme.caption!.apply(
                                          color: state.verificationState.color,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: DisplayStatus(
                          credentialModel: widget.credentialModel,
                          displayLabel: true,
                        ),
                      ),
                    )
                  ],
                ),
                if (outputDescriptors != null) ...[
                  const SizedBox(height: 10),
                  BackgroundCard(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CredentialSelectionManifestDisplayDescriptor(
                      outputDescriptors: outputDescriptors,
                      credentialModel: widget.credentialModel,
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                TextButton.icon(
                  icon: Image.asset(IconStrings.trash),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.transparent,
                  ),
                  onPressed: delete,
                  label: Text(
                    l10n.credentialDetailDelete,
                    style: Theme.of(context).textTheme.deleteThisCertificate,
                  ),
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
