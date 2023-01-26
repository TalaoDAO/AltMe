import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SIOPV2CredentialPickPage extends StatelessWidget {
  const SIOPV2CredentialPickPage({
    super.key,
    required this.credentials,
    required this.sIOPV2Param,
    required this.issuer,
  });

  final List<CredentialModel> credentials;
  final SIOPV2Param sIOPV2Param;
  final Issuer issuer;

  static Route<dynamic> route({
    required List<CredentialModel> credentials,
    required SIOPV2Param sIOPV2Param,
    required Issuer issuer,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => SIOPV2CredentialPickPage(
          credentials: credentials,
          sIOPV2Param: sIOPV2Param,
          issuer: issuer,
        ),
        settings: const RouteSettings(name: '/SIOPV2CredentialPickPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SIOPV2CredentialPickCubit(scanCubit: context.read<ScanCubit>()),
      child: SIOPV2CredentialPickView(
        credentials: credentials,
        sIOPV2Param: sIOPV2Param,
        issuer: issuer,
      ),
    );
  }
}

class SIOPV2CredentialPickView extends StatelessWidget {
  const SIOPV2CredentialPickView({
    super.key,
    required this.credentials,
    required this.sIOPV2Param,
    required this.issuer,
  });

  final List<CredentialModel> credentials;
  final SIOPV2Param sIOPV2Param;
  final Issuer issuer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<SIOPV2CredentialPickCubit, SIOPV2CredentialPickState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
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
            titleTrailing: const WhiteCloseButton(),
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            navigation: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Tooltip(
                  message: l10n.credentialPickPresent,
                  child: Builder(
                    builder: (context) {
                      return MyGradientButton(
                        onPressed: () async {
                          bool authenticated = false;
                          await Navigator.of(context).push<void>(
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
                              .read<SIOPV2CredentialPickCubit>()
                              .presentCredentialToSIOPV2Request(
                                credential: credentials[state.index],
                                sIOPV2Param: sIOPV2Param,
                                issuer: issuer,
                              );
                        },
                        text: l10n.credentialPickPresent,
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
                  style: Theme.of(context).textTheme.credentialSubtitle,
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  credentials.length,
                  (index) => CredentialsListPageItem(
                    credentialModel: credentials[index],
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
