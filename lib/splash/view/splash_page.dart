import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/drawer/drawer.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/key/onboarding_key.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/qr_code/qr_code.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        secureStorageProvider: secure_storage.getSecureStorage,
        didCubit: context.read<DIDCubit>(),
      ),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  StreamSubscription? _sub;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((AnimationStatus status) async {
        await context.read<ThemeCubit>().getCurrentTheme();
        if (status == AnimationStatus.completed) {
          //ignore: use_build_context_synchronously
          await context.read<SplashCubit>().initialiseApp();
        }
      });
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks(BuildContext context) {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen(
        (Uri? uri) {
          if (!mounted) return;
          debugPrint('got uri: $uri');
          uri?.queryParameters.forEach((key, value) async {
            if (key == 'uri') {
              final url = value.replaceAll(RegExp(r'ß^\"|\"$'), '');
              context.read<DeepLinkCubit>().addDeepLink(url);
              final key = await secure_storage.getSecureStorage.get(
                SecureStorageKeys.key,
              );
              if (key != null) {
                await context.read<QRCodeScanCubit>().deepLink();
              }
            }
          });
        },
        onError: (Object err) {
          if (!mounted) return;
          debugPrint('got err: $err');
        },
      );
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri(BuildContext context) async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a widget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          debugPrint('no initial uri');
        } else {
          debugPrint('got initial uri: $uri');
          if (!mounted) return;
          debugPrint('got uri: $uri');
          uri.queryParameters.forEach((key, value) {
            if (key == 'uri') {
              /// add uri to deepLink cubit
              final url = value.replaceAll(RegExp(r'^\"|\"$'), '');
              context.read<DeepLinkCubit>().addDeepLink(url);
            }
          });
        }
        if (!mounted) return;
      } on services.PlatformException {
        // Platform messages may fail but we ignore the exception
        debugPrint('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        debugPrint('malformed initial uri: $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleIncomingLinks(context);
    _handleInitialUri(context);
    final FlavorCubit flavorCubit = context.read<FlavorCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashStatus>(
          listener: (BuildContext context, SplashStatus state) {
            if (state == SplashStatus.onboarding) {
              Navigator.of(context).push<void>(OnBoardingStartPage.route());
            }
            if (state == SplashStatus.bypassOnBoarding) {
              Navigator.of(context).push<void>(CredentialsListPage.route());
            }
          },
        ),
        BlocListener<WalletCubit, WalletState>(
          listener: (BuildContext context, WalletState state) {
            if (state.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }
            if (state.status == WalletStatus.delete) {
              Navigator.of(context).pop();
            }
            if (state.status == WalletStatus.reset) {
              Navigator.of(context)
                  .pushReplacement<void, void>(OnBoardingKeyPage.route());
            }
          },
        ),
        BlocListener<ScanCubit, ScanState>(
          listener: (BuildContext context, ScanState state) async {
            final l10n = context.l10n;

            if (state.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }

            if (state.status == ScanStatus.askPermissionDidAuth) {
              final scanCubit = context.read<ScanCubit>();
              final state = scanCubit.state;
              final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title:
                          '''${l10n.credentialPresentTitleDIDAuth}\n${l10n.confimrDIDAuth}''',
                      yes: l10n.showDialogYes,
                      no: l10n.showDialogNo,
                    ),
                  ) ??
                  false;

              if (confirm) {
                await scanCubit.getDIDAuthCHAPI(
                  keyId: state.keyId!,
                  done: state.done!,
                  uri: state.uri!,
                  challenge: state.challenge!,
                  domain: state.domain!,
                );
              } else {
                Navigator.of(context).pop();
              }
            }
            if (state.status == ScanStatus.success) {
              Navigator.of(context).pop();
            }
            if (state.status == ScanStatus.error) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<QRCodeScanCubit, QRCodeScanState>(
          listener: (BuildContext context, QRCodeScanState state) async {
            final l10n = context.l10n;

            if (state.status == QrScanStatus.acceptHost) {
              if (state.uri != null) {
                final profileCubit = context.read<ProfileCubit>();
                var approvedIssuer = Issuer.emptyIssuer();
                final isIssuerVerificationSettingTrue =
                    profileCubit.state.model.issuerVerificationSetting;
                if (isIssuerVerificationSettingTrue) {
                  try {
                    approvedIssuer = await CheckIssuer(
                      DioClient(Urls.checkIssuerServerUrl, Dio()),
                      Urls.checkIssuerServerUrl,
                      state.uri!,
                    ).isIssuerInApprovedList();
                  } catch (e) {
                    if (e is MessageHandler) {
                      AlertMessage.showStateMessage(
                        context: context,
                        stateMessage: StateMessage.error(messageHandler: e),
                      );
                    } else {
                      AlertMessage.showStateMessage(
                        context: context,
                        stateMessage: StateMessage.error(
                          messageHandler: ResponseMessage(
                            ResponseString
                                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
                          ),
                        ),
                      );
                    }
                    return;
                  }
                }

                final acceptHost = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          title: l10n.scanPromptHost,
                          subtitle: (approvedIssuer.did.isEmpty)
                              ? state.uri!.host
                              : '''${approvedIssuer.organizationInfo.legalName}\n${approvedIssuer.organizationInfo.currentAddress}''',
                          yes: l10n.communicationHostAllow,
                          no: l10n.communicationHostDeny,
                          lock: state.uri!.scheme == 'http',
                        );
                      },
                    ) ??
                    false;

                if (acceptHost) {
                  await context.read<QRCodeScanCubit>().accept(uri: state.uri!);
                } else {
                  AlertMessage.showStateMessage(
                    context: context,
                    stateMessage: StateMessage(
                      messageHandler: ResponseMessage(
                        ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
                      ),
                      type: MessageType.error,
                    ),
                  );
                  return;
                }
              }
            }

            if (state.status == QrScanStatus.success) {
              if (state.route != null) {
                if (state.isDeepLink) {
                  await Navigator.of(context).push<void>(state.route!);
                } else {
                  await Navigator.of(context)
                      .pushReplacement<void, void>(state.route!);
                }
              }
            }

            if (state.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }
          },
        )
      ],
      child: BasePage(
        backgroundColor: const Color(0xffffffff),
        scrollView: false,
        body: Center(
          child: SizedBox.square(
            dimension: MediaQuery.of(context).size.width * 0.4,
            child: ScaleTransition(
              key: const Key('scaleTransition'),
              scale: _scaleAnimation,
              child: Image.asset(
                flavorCubit.state == FlavorMode.development
                    ? ImageStrings.splashDev
                    : flavorCubit.state == FlavorMode.staging
                        ? ImageStrings.splashStage
                        : ImageStrings.splash,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
