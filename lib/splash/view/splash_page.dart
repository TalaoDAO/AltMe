import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/enterprise.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/splash/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final Uri? initialUri = await _handleInitialUri(context);

        await context.read<SplashCubit>().initialiseApp();

        /// In case app is opened through deeplink we need to handle
        /// incoming request.
        if (initialUri != null) {
          await securityCheck(
            context: context,
            onSuccess: () async {
              await Navigator.of(context).push<void>(DashboardPage.route());

              await processIncomingUri(
                initialUri,
                context,
              );
            },
            localAuthApi: LocalAuthApi(),
          );
        }
      },
    );
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
    final log = getLogger('DeepLink - _handleIncomingLinks');

    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen(
        (Uri? uri) async {
          if (!mounted) return;
          log.i('got uri: $uri');
          await processIncomingUri(uri, context);
        },
        onError: (Object err) {
          if (!mounted) return;
          log.e('got err: $err');
        },
      );
    }
  }

  bool isPolygonFunctionCalled = false;

  String? _deeplink;

  Future<void> processIncomingUri(Uri? uri, BuildContext context) async {
    final l10n = context.l10n;
    String beaconData = '';
    bool isBeaconRequest = false;

    Timer.periodic(const Duration(seconds: 3), (timer) {
      timer.cancel();
      _deeplink = null;
    });

    if (_deeplink != null && _deeplink == uri.toString()) {
      return;
    }

    _deeplink = uri.toString();

    if (uri.toString().startsWith('${Urls.appDeepLink}/dashboard')) {
      await Navigator.pushAndRemoveUntil<void>(
        context,
        DashboardPage.route(),
        (Route<dynamic> route) => route.isFirst,
      );
      return;
    }

    if (uri.toString().startsWith(Parameters.oidc4vcUniversalLink)) {
      await context.read<QRCodeScanCubit>().authorizedFlowStart(uri!);
      return;
    }

    if (uri.toString().startsWith('configuration://?')) {
      await context.read<EnterpriseCubit>().requestTheConfiguration(
            uri: uri!,
            qrCodeScanCubit: context.read<QRCodeScanCubit>(),
          );
      return;
    }

    if (uri.toString().startsWith(Parameters.authorizeEndPoint)) {
      context.read<DeepLinkCubit>().addDeepLink(uri!.toString());
      await context.read<QRCodeScanCubit>().deepLink();
      return;
    }

    if (uri.toString().startsWith('iden3comm://')) {
      /// if wallet has not been created then alert user
      final ssiKey =
          await secure_storage.getSecureStorage.get(SecureStorageKeys.ssiKey);
      if (ssiKey == null) {
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              title: l10n.createWalletMessage,
            );
          },
        );
        return;
      }

      /// decrypt iden3MessageEntity
      final encryptedIden3MessageEntity =
          uri.toString().split('iden3comm://?i_m=')[1];

      final JWTDecode jwtDecode = JWTDecode();
      final iden3MessageEntityJson =
          jwtDecode.parsePolygonIdJwtHeader(encryptedIden3MessageEntity);

      if (isPolygonFunctionCalled) return;

      isPolygonFunctionCalled = true;

      await context
          .read<PolygonIdCubit>()
          .polygonIdFunction(jsonEncode(iden3MessageEntityJson));

      // Reset the flag variable after 2 seconds
      Timer(const Duration(seconds: 1), () {
        isPolygonFunctionCalled = false;
      });
    }

    uri!.queryParameters.forEach((key, value) async {
      if (key == 'uri') {
        final url = value.replaceAll(RegExp(r'ß^\"|\"$'), '');
        context.read<DeepLinkCubit>().addDeepLink(url);
        final ssiKey =
            await secure_storage.getSecureStorage.get(SecureStorageKeys.ssiKey);
        if (ssiKey != null) {
          await context.read<QRCodeScanCubit>().deepLink();
          return;
        }
      }
      if (key == 'type' && value == 'tzip10') {
        isBeaconRequest = true;
      }
      if (key == 'data') {
        beaconData = value;
      }
    });

    if (isOIDC4VCIUrl(uri)) {
      context.read<DeepLinkCubit>().addDeepLink(uri.toString());
      await context.read<QRCodeScanCubit>().deepLink();
      return;
    }

    if (isBeaconRequest && beaconData != '') {
      unawaited(
        context.read<BeaconCubit>().peerFromDeepLink(beaconData),
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
  Future<Uri?> _handleInitialUri(BuildContext context) async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a widget that will be disposed of (ex. a navigation route change).
    final log = getLogger('DeepLink - _handleInitialUri');
    if (!mounted) return null;
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await getInitialUri();
        if (uri == null) {
          log.i('no initial uri');
        } else {
          log.i('got initial uri: $uri');
          if (!mounted) return null;
          log.i('got uri: $uri');
          return uri;
        }
      } on services.PlatformException {
        // Platform messages may fail but we ignore the exception
        log.e('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return null;
        log.e('malformed initial uri: $err');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _handleIncomingLinks(context);
    _handleInitialUri(context);
    return MultiBlocListener(
      listeners: [
        splashBlocListener,
        walletBlocListener,
        credentialsBlocListener,
        walletBlocAccountChangeListener,
        scanBlocListener,
        qrCodeBlocListener,
        beaconBlocListener,
        walletConnectBlocListener,
        polygonIdBlocListener,
        enterpriseBlocListener,
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status != AppStatus.success) return Container();

          return BasePage(
            backgroundColor: Theme.of(context).colorScheme.surface,
            scrollView: false,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(flex: 2),
                      WalletLogo(
                        width: MediaQuery.of(context).size.shortestSide * 0.6,
                        height: MediaQuery.of(context).size.longestSide * 0.2,
                      ),
                      const Spacer(flex: 2),
                      TitleText(profileModel: state.model),
                      const Spacer(flex: 1),
                      SubTitle(profileModel: state.model),
                      const Spacer(flex: 5),
                      // const LoadingText(),
                      // const SizedBox(height: 10),
                      BlocBuilder<SplashCubit, SplashState>(
                        builder: (context, state) {
                          return TweenAnimationBuilder(
                            tween:
                                Tween<double>(begin: 0, end: state.loadedValue),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return LoadingProgress(value: value);
                            },
                          );
                        },
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
