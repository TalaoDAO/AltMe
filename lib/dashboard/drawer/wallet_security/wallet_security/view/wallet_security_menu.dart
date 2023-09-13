import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class WalletSecurityMenu extends StatelessWidget {
  const WalletSecurityMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const WalletSecurityMenu(),
      settings: const RouteSettings(name: '/WalletSecurityMenu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WalletSecurityView();
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
              showDialog: true,
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
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
                        final pinCode = await getSecureStorage
                            .get(SecureStorageKeys.pinCode);
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
                      trailing: SizedBox(
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
                                await context
                                    .read<ProfileCubit>()
                                    .setFingerprintEnabled(enabled: value);
                                await showDialog<bool>(
                                  context: context,
                                  builder: (context) => ConfirmDialog(
                                    title: value
                                        ? l10n.biometricsEnabledMessage
                                        : l10n.biometricsDisabledMessage,
                                    yes: l10n.ok,
                                    showNoButton: false,
                                  ),
                                );
                              }
                            } else {
                              await showDialog<bool>(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  title: l10n.biometricsNotSupported,
                                  subtitle: l10n
                                      .deviceDoNotSupportBiometricsAuthentication, // ignore: lines_longer_than_80_chars
                                  yes: l10n.ok,
                                ),
                              );
                            }
                          },
                          value: state.model.isBiometricEnabled,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DrawerItem(
                      title: l10n.alert,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .setAlertEnabled(enabled: value);
                          },
                          value: state.model.isAlertEnabled,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DrawerItem(
                      title: l10n.userConsentForIssuerAccess,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .setUserConsentForIssuerAccess(enabled: value);
                          },
                          value: state.model.userConsentForIssuerAccess,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DrawerItem(
                      title: l10n.userConsentForVerifierAccess,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .setUserConsentForVerifierAccess(
                                  enabled: value,
                                );
                          },
                          value: state.model.userConsentForVerifierAccess,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DrawerItem(
                      title: l10n.userPINCodeForAuthentication,
                      trailing: SizedBox(
                        height: 25,
                        child: Switch(
                          onChanged: (value) async {
                            await context
                                .read<ProfileCubit>()
                                .setUserPINCodeForAuthentication(
                                  enabled: value,
                                );
                          },
                          value: state.model.userPINCodeForAuthentication,
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DrawerItem(
                      title: l10n.showWalletRecoveryPhrase,
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                title: l10n.warningDialogTitle,
                                subtitle: l10n.warningDialogSubtitle,
                                yes: l10n.showDialogYes,
                                no: l10n.showDialogNo,
                              ),
                            ) ??
                            false;

                        if (confirm) {
                          final pinCode = await getSecureStorage
                              .get(SecureStorageKeys.pinCode);
                          if (pinCode?.isEmpty ?? true) {
                            setNewPinCode(context, l10n);
                          } else {
                            await Navigator.of(context).push<void>(
                              PinCodePage.route(
                                isValidCallback: () => Navigator.of(context)
                                    .push<void>(RecoveryKeyPage.route()),
                                restrictToBack: false,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
