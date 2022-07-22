import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueryByExampleCredentialPickPage extends StatelessWidget {
  const QueryByExampleCredentialPickPage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  final Uri uri;
  final Map<String, dynamic> preview;

  static Route route(Uri routeUri, Map<String, dynamic> preview) =>
      MaterialPageRoute<void>(
        builder: (context) =>
            QueryByExampleCredentialPickPage(uri: routeUri, preview: preview),
        settings:
            const RouteSettings(name: '/QueryByExampleCredentialPickPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final credentialQueryList =
            context.read<QueryByExampleCubit>().state.credentialQuery;
        return QueryByExampleCredentialPickCubit(
          credentialQuery:
              credentialQueryList.isNotEmpty ? credentialQueryList.first : null,
          credentialList: context.read<WalletCubit>().state.credentials,
        );
      },
      child: QueryByExampleCredentialPickView(uri: uri, preview: preview),
    );
  }
}

class QueryByExampleCredentialPickView extends StatelessWidget {
  const QueryByExampleCredentialPickView({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  final Uri uri;
  final Map<String, dynamic> preview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final queryByExampleCubit = context.read<QueryByExampleCubit>().state;
    var reasonList = '';
    if (queryByExampleCubit.type != '') {
      /// get all the reasons
      for (final e in queryByExampleCubit.credentialQuery) {
        final _reason = e.reason;
        if (_reason != null) {
          reasonList += '${GetTranslation.getTranslation(_reason, l10n)}\n';
        }
      }
    }
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<QueryByExampleCredentialPickCubit,
            QueryByExampleCredentialPickState>(
          builder: (context, queryState) {
            return WillPopScope(
              onWillPop: () async {
                if (context.read<ScanCubit>().state.status ==
                    ScanStatus.loading) {
                  return false;
                }
                return true;
              },
              child: BlocListener<ScanCubit, ScanState>(
                listener: (BuildContext context, ScanState scanState) async {
                  if (scanState.status == ScanStatus.loading) {
                    LoadingView().show(context: context);
                  } else {
                    LoadingView().hide();
                  }
                },
                child: BasePage(
                  title: l10n.credentialPickTitle,
                  titleTrailing: const WhiteCloseButton(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  navigation: SafeArea(
                    child: queryState.filteredCredentialList.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            child: Tooltip(
                              message: l10n.credentialPickPresent,
                              child: Builder(
                                builder: (context) {
                                  return MyGradientButton(
                                    onPressed: queryState.selected == null
                                        ? null
                                        : () async {
                                            /// Authenticate
                                            bool authenticated = false;
                                            await Navigator.of(context)
                                                .push<void>(
                                              PinCodePage.route(
                                                restrictToBack: false,
                                                isValidCallback: () {
                                                  authenticated = true;
                                                },
                                              ),
                                            );

                                            if (!authenticated) {
                                              return;
                                            }

                                            final scanCubit =
                                                context.read<ScanCubit>();
                                            await scanCubit
                                                .verifiablePresentationRequest(
                                              url: uri.toString(),
                                              keyId: SecureStorageKeys.ssiKey,
                                              credentials: [
                                                queryState
                                                        .filteredCredentialList[
                                                    queryState.selected!]
                                              ],
                                              challenge: preview['challenge']
                                                  as String,
                                              domain:
                                                  preview['domain'] as String,
                                            );

                                            return;
                                          },
                                    text: l10n.credentialPickPresent,
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  body: Column(
                    children: <Widget>[
                      Text(
                        reasonList == ''
                            ? l10n.credentialPickSelect
                            : l10n.credentialPresentConfirm,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        reasonList,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        queryState.filteredCredentialList.length,
                        (index) => CredentialsListPageItem(
                          credentialModel:
                              queryState.filteredCredentialList[index],
                          selected: queryState.selected == index,
                          onTap: () => context
                              .read<QueryByExampleCredentialPickCubit>()
                              .toggle(index),
                        ),
                      ),
                      if (queryState.filteredCredentialList.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            l10n.credentialSelectionListEmptyError,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
