import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SIOPV2CredentialPickPage extends StatefulWidget {
  const SIOPV2CredentialPickPage({
    Key? key,
    required this.credentials,
    required this.sIOPV2Param,
  }) : super(key: key);

  final List<CredentialModel> credentials;
  final SIOPV2Param sIOPV2Param;

  static Route route({
    required List<CredentialModel> credentials,
    required SIOPV2Param sIOPV2Param,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) =>
              SIOPV2CredentialPickCubit(scanCubit: context.read<ScanCubit>()),
          child: SIOPV2CredentialPickPage(
            credentials: credentials,
            sIOPV2Param: sIOPV2Param,
          ),
        ),
        settings: const RouteSettings(name: '/SIOPV2CredentialPickPage'),
      );

  @override
  _SIOPV2CredentialPickPageState createState() =>
      _SIOPV2CredentialPickPageState();
}

class _SIOPV2CredentialPickPageState extends State<SIOPV2CredentialPickPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    OverlayEntry? _overlay;

    return BlocConsumer<SIOPV2CredentialPickCubit, SIOPV2CredentialPickState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          _overlay = OverlayEntry(
            builder: (_) => const LoadingDialog(),
          );
          Overlay.of(context)!.insert(_overlay!);
        } else {
          _overlay!.remove();
          _overlay = null;
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (context.read<SIOPV2CredentialPickCubit>().state.status ==
                AppStatus.loading) {
              return false;
            }
            return true;
          },
          child: BasePage(
            title: l10n.credentialPickTitle,
            titleTrailing: IconButton(
              onPressed: () {
                if (context.read<SIOPV2CredentialPickCubit>().state.status !=
                    AppStatus.loading) {
                  Navigator.of(context).pop();
                }
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
                          context
                              .read<SIOPV2CredentialPickCubit>()
                              .presentCredentialToSIOPV2Request(
                                credential: widget.credentials[state.index],
                                sIOPV2Param: widget.sIOPV2Param,
                              );
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
                  l10n.siopV2credentialPickSelect,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  widget.credentials.length,
                  (index) => CredentialsListPageItem(
                    credentialModel: widget.credentials[index],
                    selected: state.index == index,
                    onTap: () =>
                        context.read<SIOPV2CredentialPickCubit>().toggle(index),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
