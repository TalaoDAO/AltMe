import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class ProtectWalletPage extends StatelessWidget {
  const ProtectWalletPage({
    super.key,
    this.routeType,
  });

  final WalletRouteType? routeType;

  static Route<dynamic> route({
    WalletRouteType? routeType,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ProtectWalletPage(
        routeType: routeType,
      ),
      settings: const RouteSettings(name: '/ProtectWalletPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingGenPhraseCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
        splashCubit: context.read<SplashCubit>(),
      ),
      child: ProtectWalletView(
        routeType: routeType,
      ),
    );
  }
}

class ProtectWalletView extends StatefulWidget {
  const ProtectWalletView({
    super.key,
    this.routeType,
  });

  final WalletRouteType? routeType;

  @override
  State<ProtectWalletView> createState() => _ProtectWalletViewState();
}

class _ProtectWalletViewState extends State<ProtectWalletView> {
  final localAuthApi = LocalAuthApi();

  bool get byPassScreen => !Parameters.walletHandlesCrypto;

  bool get isFromOnboarding => widget.routeType != null;

  Future<void> createImportAccount() async {
    if (widget.routeType == WalletRouteType.create) {
      if (byPassScreen) {
        await context.read<OnboardingCubit>().emitOnboardingProcessing();

        final mnemonic = bip39.generateMnemonic().split(' ');
        await context
            .read<OnBoardingGenPhraseCubit>()
            .generateSSIAndCryptoAccount(mnemonic);
      } else {
        await Navigator.of(context).push<void>(OnBoardingGenPhrasePage.route());
      }
    } else {
      await Navigator.of(context).push<void>(
        ImportWalletPage.route(
          isFromOnboarding: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<OnBoardingGenPhraseCubit, OnBoardingGenPhraseState>(
      listener: (context, state) async {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          if (state.status == AppStatus.success) {
            await context.read<AltmeChatSupportCubit>().init();
          }
          LoadingView().hide();
        }

        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }

        if (state.status == AppStatus.success) {
          await Navigator.pushAndRemoveUntil<void>(
            context,
            WalletReadyPage.route(),
            (Route<dynamic> route) => route.isFirst,
          );
        }
      },
      child: BasePage(
        scrollView: false,
        useSafeArea: true,
        padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceXSmall),
        titleLeading: const BackLeadingButton(),
        backgroundColor: Theme.of(context).colorScheme.drawerBackground,
        title: l10n.protectYourWallet,
        titleAlignment: Alignment.topCenter,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            final walletProtectionType =
                profileState.model.walletProtectionType;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.protectYourWalletMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall3,
                ),
                const SizedBox(height: Sizes.spaceNormal),
                ProtectWidget(
                  title: l10n.pinUnlock,
                  subtitle: l10n.secureWithDevicePINOnly,
                  image: IconStrings.pincode,
                  isSelected: !isFromOnboarding &&
                      walletProtectionType == WalletProtectionType.pinCode,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      EnterNewPinCodePage.route(
                        isFromOnboarding: isFromOnboarding,
                        isValidCallback: () async {
                          await context
                              .read<ProfileCubit>()
                              .setWalletProtectionType(
                                walletProtectionType:
                                    WalletProtectionType.pinCode,
                              );
                          Navigator.of(context).pop();
                          if (isFromOnboarding) {
                            await createImportAccount();
                          } else {
                            AlertMessage.showStateMessage(
                              context: context,
                              stateMessage: StateMessage.success(
                                showDialog: true,
                                stringMessage:
                                    l10n.yourPinCodeChangedSuccessfully,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                ProtectWidget(
                  title: l10n.biometricUnlock,
                  subtitle: l10n.secureWithFingerprint,
                  image: IconStrings.right,
                  isSelected: !isFromOnboarding &&
                      walletProtectionType == WalletProtectionType.biometrics,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      ActiviateBiometricsPage.route(
                        isFromOnboarding: isFromOnboarding,
                        onAction: ({required bool isEnabled}) async {
                          if (isEnabled) {
                            await context
                                .read<ProfileCubit>()
                                .setWalletProtectionType(
                                  walletProtectionType:
                                      WalletProtectionType.biometrics,
                                );
                            Navigator.of(context).pop();
                            if (isFromOnboarding) {
                              await createImportAccount();
                            } else {
                              AlertMessage.showStateMessage(
                                context: context,
                                stateMessage: StateMessage.success(
                                  showDialog: true,
                                  stringMessage: l10n.biometricsEnabledMessage,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
                ProtectWidget(
                  title: l10n.pinUnlockAndBiometric2FA,
                  subtitle: l10n.secureWithFingerprintAndPINBackup,
                  image: IconStrings.lock,
                  isSelected: !isFromOnboarding &&
                      walletProtectionType == WalletProtectionType.FA2,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      EnterNewPinCodePage.route(
                        isFromOnboarding: isFromOnboarding,
                        isValidCallback: () {
                          Navigator.of(context).pushReplacement<void, void>(
                            ActiviateBiometricsPage.route(
                              isFromOnboarding: isFromOnboarding,
                              onAction: ({required bool isEnabled}) async {
                                if (isEnabled) {
                                  await context
                                      .read<ProfileCubit>()
                                      .setWalletProtectionType(
                                        walletProtectionType:
                                            WalletProtectionType.FA2,
                                      );
                                  Navigator.of(context).pop();
                                  if (isFromOnboarding) {
                                    await createImportAccount();
                                  } else {
                                    AlertMessage.showStateMessage(
                                      context: context,
                                      stateMessage: StateMessage.success(
                                        showDialog: true,
                                        stringMessage: l10n
                                            .twoFactorAuthenticationHasBeenEnabled,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
