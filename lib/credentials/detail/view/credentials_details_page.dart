import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/qr_code/qr_code.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

class CredentialsDetailsPage extends StatefulWidget {
  const CredentialsDetailsPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CredentialModel item;

  static Route route(CredentialModel routeItem) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider<CredentialDetailsCubit>(
        create: (context) => CredentialDetailsCubit(
          walletCubit: context.read<WalletCubit>(),
          didKitProvider: DIDKitProvider(),
        ),
        child: CredentialsDetailsPage(item: routeItem),
      ),
      settings: const RouteSettings(name: '/CredentialsDetailsPages'),
    );
  }

  @override
  _CredentialsDetailsPageState createState() => _CredentialsDetailsPageState();
}

class _CredentialsDetailsPageState extends State<CredentialsDetailsPage> {
  final logger = Logger('altme-wallet/credentials/detail');

  @override
  void initState() {
    super.initState();
    context.read<CredentialDetailsCubit>().setTitle(widget.item.alias!);
    context.read<CredentialDetailsCubit>().verify(widget.item);
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
      await context.read<WalletCubit>().deleteById(widget.item.id);
    }
  }

  Future<void> _edit() async {
    final l10n = context.l10n;
    logger.info('Start edit flow');
    final credentialDetailsCubit = context.read<CredentialDetailsCubit>();
    final newAlias = await showDialog<String>(
      context: context,
      builder: (_) => TextFieldDialog(
        title: l10n.credentialDetailEditConfirmationDialog,
        initialValue: credentialDetailsCubit.state.title,
        yes: l10n.credentialDetailEditConfirmationDialogYes,
        no: l10n.credentialDetailEditConfirmationDialogNo,
      ),
    );

    logger.info('Edit flow answered with: $newAlias');

    if (newAlias != null && newAlias != credentialDetailsCubit.state.title) {
      logger.info('New alias is different, going to update credential');
      await credentialDetailsCubit.update(widget.item, newAlias);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CredentialDetailsCubit, CredentialDetailsState>(
      builder: (context, state) {
        return BasePage(
          title: state.title != '' ? state.title : l10n.credential,
          titleTag: 'credential/${state.title ?? widget.item.id}/issuer',
          titleLeading: const BackLeadingButton(),
          titleTrailing: IconButton(
            onPressed: _edit,
            icon: const Icon(Icons.edit),
          ),
          navigation: widget.item.shareLink != ''
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
                              widget.item.id,
                              widget.item,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icon/qr-code.svg',
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DocumentWidget(
                model: widget.item,
              ),
              const SizedBox(height: 64),
              ...<Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      l10n.credentialDetailStatus,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                Row(
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
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(color: state.verificationState.color),
                      ),
                    ),
                  ],
                ),
              ],
              Center(
                child: DisplayStatus(item: widget.item, displayLabel: true),
              ),
              const SizedBox(height: 64),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.error.withOpacity(0.1),
                ),
                onPressed: delete,
                child: Text(
                  l10n.credentialDetailDelete,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .apply(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
