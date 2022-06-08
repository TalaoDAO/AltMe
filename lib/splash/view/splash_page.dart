import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/splash/view/widgets/widgets.dart';
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
        homeCubit: context.read<HomeCubit>(),
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

class _SplashViewState extends State<SplashView> {
  StreamSubscription? _sub;

  @override
  void initState() {
    Future<void>.delayed(const Duration(milliseconds: 5 * 1000), () async {
      await context.read<SplashCubit>().initialiseApp();
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
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
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          listener: (BuildContext context, SplashState state) {
            if (state.status == SplashStatus.routeToPassCode) {
              Navigator.of(context).push<void>(
                PinCodePage.route(
                  isValidCallback: () {
                    Navigator.of(context).push<void>(HomePage.route());
                  },
                ),
              );
            }
            if (state.status == SplashStatus.routeToHomePage) {
              Navigator.of(context).push<void>(HomePage.route());
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
              /// Removes every stack except first route (splashPage)
              Navigator.pushAndRemoveUntil<void>(
                context,
                HomePage.route(),
                (Route<dynamic> route) => route.isFirst,
              );
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
                          '''${l10n.credentialPresentTitleDIDAuth}\n\n${l10n.confimrDIDAuth}''',
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
                    profileCubit.state.model.issuerVerificationUrl != '';
                if (isIssuerVerificationSettingTrue) {
                  try {
                    approvedIssuer = await CheckIssuer(
                      DioClient(Urls.checkIssuerTalaoUrl, Dio()),
                      profileCubit.state.model.issuerVerificationUrl,
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
                          // TODO(bibash): look into this lock thing
                          //lock: state.uri!.scheme == 'http',
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
        scrollView: false,
        padding: EdgeInsets.zero,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.darkGradientStartColor,
                      Theme.of(context).colorScheme.darkGradientEndColor
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Spacer(
                      flex: 4,
                    ),
                    AltMeLogo(),
                    Spacer(
                      flex: 1,
                    ),
                    TitleText(),
                    Spacer(
                      flex: 1,
                    ),
                    SubTitle(),
                    Spacer(
                      flex: 2,
                    ),
                    CityImage(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.darkGradientEndColor,
                      Theme.of(context).colorScheme.darkGradientStartColor,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Spacer(
                      flex: 2,
                    ),
                    LoadingText(),
                    SizedBox(
                      height: Sizes.spaceSmall,
                    ),
                    LoadingProgress(),
                    Spacer(
                      flex: 4,
                    ),
                    VersionText()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
