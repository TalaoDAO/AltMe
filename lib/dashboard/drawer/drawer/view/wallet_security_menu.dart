import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class WalletSecurityMenu extends StatelessWidget {
  const WalletSecurityMenu({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const WalletSecurityMenu());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletSecurityCubit(),
      child: WalletSecurityView(),
    );
  }
}

class WalletSecurityView extends StatelessWidget {
  WalletSecurityView({super.key});
  final localAuthApi = LocalAuthApi();

  //method for set new pin code
  void setNewPinCode(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    Navigator.of(context).push<void>(
      EnterNewPinCodePage.route(
        isFromOnboarding: false,
        isValidCallback: () {
          Navigator.of(context).pop();
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: StateMessage.success(
              stringMessage: l10n.yourPinCodeChangedSuccessfully,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.drawerBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BackLeadingButton(
                  padding: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const Center(
                  child: AltMeLogo(size: 90),
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerItem(
                  title: l10n.changePinCode,
                  onTap: () async {
                    final pinCode =
                        await getSecureStorage.get(SecureStorageKeys.pinCode);
                    if (pinCode?.isEmpty ?? true) {
                      setNewPinCode(context, l10n);
                    } else {
                      await Navigator.of(context).push<void>(
                        PinCodePage.route(
                          isValidCallback: () =>
                              setNewPinCode.call(context, l10n),
                          restrictToBack: false,
                        ),
                      );
                    }
                  },
                ),
                DrawerItem(
                  title: l10n.drawerBiometrics,
                  trailing:
                      BlocBuilder<WalletSecurityCubit, WalletSecurityState>(
                    builder: (context, walletSecurityState) {
                      return SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            final hasBiometrics =
                                await localAuthApi.hasBiometrics();
                            if (hasBiometrics) {
                              final result = await localAuthApi.authenticate(
                                localizedReason:
                                    l10n.scanFingerprintToAuthenticate,
                              );
                              if (result) {
                                await getSecureStorage.set(
                                  SecureStorageKeys.fingerprintEnabled,
                                  value.toString(),
                                );
                                context
                                    .read<WalletSecurityCubit>()
                                    .setFingerprintEnabled(enabled: value);
                                await showDialog<bool>(
                                  context: context,
                                  builder: (context) => InfoDialog(
                                    title: value
                                        ? l10n.biometricsEnabledMessage
                                        : l10n.biometricsDisabledMessage,
                                    button: l10n.ok,
                                  ),
                                );
                              }
                            } else {
                              await showDialog<bool>(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  title: l10n.biometricsNotSupported,
                                  subtitle: l10n
                                      .yourDeviceDoseNotSupportBiometricsAuthentication, // ignore: lines_longer_than_80_chars
                                  yes: l10n.ok,
                                ),
                              );
                            }
                          },
                          value: walletSecurityState.isBiometricsEnabled,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
