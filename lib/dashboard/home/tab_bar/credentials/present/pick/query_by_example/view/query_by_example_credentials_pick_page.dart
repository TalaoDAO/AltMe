import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueryByExampleCredentialPickPage extends StatelessWidget {
  const QueryByExampleCredentialPickPage({
    super.key,
    required this.uri,
    required this.preview,
    required this.issuer,
    required this.credentialQueryIndex,
    required this.credentialsToBePresented,
  });

  final Uri uri;
  final Map<String, dynamic> preview;
  final Issuer issuer;
  final int credentialQueryIndex;
  final List<CredentialModel> credentialsToBePresented;

  static Route<dynamic> route({
    required Uri uri,
    required Map<String, dynamic> preview,
    required Issuer issuer,
    required int credentialQueryIndex,
    required List<CredentialModel> credentialsToBePresented,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => QueryByExampleCredentialPickPage(
          uri: uri,
          preview: preview,
          issuer: issuer,
          credentialQueryIndex: credentialQueryIndex,
          credentialsToBePresented: credentialsToBePresented,
        ),
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
          credentialQuery: credentialQueryList.isNotEmpty
              ? credentialQueryList[credentialQueryIndex]
              : null,
          credentialList: context.read<WalletCubit>().state.credentials,
        );
      },
      child: QueryByExampleCredentialPickView(
        uri: uri,
        preview: preview,
        issuer: issuer,
        credentialQueryIndex: credentialQueryIndex,
        credentialsToBePresented: credentialsToBePresented,
      ),
    );
  }
}

class QueryByExampleCredentialPickView extends StatelessWidget {
  const QueryByExampleCredentialPickView({
    super.key,
    required this.uri,
    required this.preview,
    required this.issuer,
    required this.credentialQueryIndex,
    required this.credentialsToBePresented,
  });

  final Uri uri;
  final Map<String, dynamic> preview;
  final Issuer issuer;
  final int credentialQueryIndex;
  final List<CredentialModel> credentialsToBePresented;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final queryByExampleCubit = context.read<QueryByExampleCubit>().state;
    var reason = '';

    if (queryByExampleCubit.credentialQuery.isNotEmpty) {
      /// Query by Example case
      if (queryByExampleCubit.credentialQuery[credentialQueryIndex].reason !=
          null) {
        reason =
            queryByExampleCubit.credentialQuery[credentialQueryIndex].reason ??
                '';
      }
    }

    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        final credentialQueryList =
            context.read<QueryByExampleCubit>().state.credentialQuery;
        return BlocBuilder<QueryByExampleCredentialPickCubit,
            QueryByExampleCredentialPickState>(
          builder: (context, queryState) {
            return BlocListener<ScanCubit, ScanState>(
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
                                          final selectedCredential =
                                              queryState.filteredCredentialList[
                                                  queryState.selected!];

                                          final updatedCredentials = List.of(
                                            credentialsToBePresented,
                                          )..add(selectedCredential);

                                          if (queryByExampleCubit
                                              .credentialQuery.isNotEmpty) {
                                            /// Query by Example case

                                            if (credentialQueryIndex + 1 !=
                                                queryByExampleCubit
                                                    .credentialQuery.length) {
                                              await Navigator.of(context)
                                                  .pushReplacement<void, void>(
                                                // ignore: lines_longer_than_80_chars
                                                QueryByExampleCredentialPickPage
                                                    .route(
                                                  uri: uri,
                                                  preview: preview,
                                                  issuer: issuer,
                                                  credentialQueryIndex:
                                                      credentialQueryIndex + 1,
                                                  credentialsToBePresented:
                                                      updatedCredentials,
                                                ),
                                              );

                                              return;
                                            }
                                          }

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

                                          await context
                                              .read<ScanCubit>()
                                              // ignore: lines_longer_than_80_chars
                                              .verifiablePresentationRequest(
                                                url: uri.toString(),
                                                keyId: SecureStorageKeys.ssiKey,
                                                credentialsToBePresented:
                                                    updatedCredentials,
                                                challenge: preview['challenge']
                                                    as String,
                                                domain:
                                                    preview['domain'] as String,
                                                issuer: issuer,
                                              );
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
                    if (credentialQueryList.isNotEmpty) ...[
                      Text(
                        '${credentialQueryIndex + 1}/${queryByExampleCubit.credentialQuery.length}',
                        style: Theme.of(context).textTheme.credentialSteps,
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      reason.trim() == '' ? l10n.credentialPickSelect : reason,
                      style: Theme.of(context).textTheme.credentialSubtitle,
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
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
