import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueryByExampleCredentialPickPage extends StatefulWidget {
  const QueryByExampleCredentialPickPage({
    Key? key,
    required this.uri,
    required this.preview,
  }) : super(key: key);

  final Uri uri;
  final Map<String, dynamic> preview;

  static Route route(Uri routeUri, Map<String, dynamic> preview) =>
      MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => QueryByExampleCredentialPickCubit(),
          child:
              QueryByExampleCredentialPickPage(uri: routeUri, preview: preview),
        ),
        settings:
            const RouteSettings(name: '/QueryByExampleCredentialPickPage'),
      );

  @override
  _QueryByExampleCredentialPickPageState createState() =>
      _QueryByExampleCredentialPickPageState();
}

class _QueryByExampleCredentialPickPageState
    extends State<QueryByExampleCredentialPickPage> {
  OverlayEntry? _overlay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final queryByExampleCubit = context.read<QueryByExampleCubit>().state;
    var reasonList = '';
    if (queryByExampleCubit.type != '') {
      /// get all the reasons
      for (final e in queryByExampleCubit.credentialQuery) {
        reasonList += '${GetTranslation.getTranslation(e.reason, l10n)}\n';
      }
    }
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<QueryByExampleCredentialPickCubit,
            QueryByExampleCredentialPickState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                if (context.read<ScanCubit>().state.status ==
                    ScanStatus.loading) {
                  return false;
                }
                return true;
              },
              child: BlocListener<ScanCubit, ScanState>(
                listener: (BuildContext context, ScanState state) async {
                  if (state.status == ScanStatus.loading) {
                    _overlay = OverlayEntry(
                      builder: (_) => const LoadingDialog(),
                    );
                    Overlay.of(context)!.insert(_overlay!);
                  } else {
                    if (_overlay != null) {
                      _overlay!.remove();
                      _overlay = null;
                    }
                  }
                },
                child: BasePage(
                  title: l10n.credentialPickTitle,
                  titleTrailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  navigation: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      height: kBottomNavigationBarHeight + 16,
                      child: Tooltip(
                        message: l10n.credentialPickPresent,
                        child: Builder(
                          builder: (context) {
                            return BaseButton.primary(
                              context: context,
                              onPressed: () {
                                if (state.selection.isEmpty) {
                                  AlertMessage.showStringMessage(
                                    context: context,
                                    message: l10n.credentialPickSelect,
                                    messageType: MessageType.error,
                                  );
                                } else {
                                  final scanCubit = context.read<ScanCubit>();
                                  scanCubit.verifiablePresentationRequest(
                                    url: widget.uri.toString(),
                                    keyId: SecureStorageKeys.key,
                                    credentials: state.selection
                                        .map((i) => walletState.credentials[i])
                                        .toList(),
                                    challenge:
                                        widget.preview['challenge'] as String,
                                    domain: widget.preview['domain'] as String,
                                  );
                                }
                              },
                              child: Text(l10n.credentialPickPresent),
                            );
                          },
                        ),
                      ),
                    ),
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
                        walletState.credentials.length,
                        (index) => CredentialsListPageItem(
                          credentialModel: walletState.credentials[index],
                          selected: state.selection.contains(index),
                          onTap: () => context
                              .read<QueryByExampleCredentialPickCubit>()
                              .toggle(index),
                        ),
                      ),
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
