import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vc/initiate_oidv4vc_credential_issuance.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:did_kit/did_kit.dart';
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
    Future<void>.delayed(const Duration(milliseconds: 500), () async {
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

  Future<void> processIncomingUri(Uri? uri, BuildContext context) async {
    final l10n = context.l10n;
    String beaconData = '';
    bool isBeaconRequest = false;
    if (uri.toString().startsWith('${Urls.appDeepLink}/dashboard')) {
      await Navigator.pushAndRemoveUntil<void>(
        context,
        DashboardPage.route(),
        (Route<dynamic> route) => route.isFirst,
      );
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
        }
      }
      if (key == 'type' && value == 'tzip10') {
        isBeaconRequest = true;
      }
      if (key == 'data') {
        beaconData = value;
      }
      if (uri.scheme == 'openid' && uri.authority == 'initiate_issuance') {
        OIDC4VCType? currentOIIDC4VCType;

        for (final oidc4vcType in OIDC4VCType.values) {
          if (oidc4vcType.isEnabled &&
              uri.toString().startsWith(oidc4vcType.offerPrefix)) {
            currentOIIDC4VCType = oidc4vcType;
          }
        }

        if (currentOIIDC4VCType != null) {
          await initiateOIDC4VCCredentialIssuance(
            uri.toString(),
            context.read<CredentialsCubit>(),
            currentOIIDC4VCType,
            secure_storage.getSecureStorage,
            DIDKitProvider(),
          );
        }
      }
    });
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
  Future<void> _handleInitialUri(BuildContext context) async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a widget that will be disposed of (ex. a navigation route change).
    final log = getLogger('DeepLink - _handleInitialUri');
    if (!mounted) return;
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await getInitialUri();
        if (uri == null) {
          log.i('no initial uri');
        } else {
          log.i('got initial uri: $uri');
          if (!mounted) return;
          log.i('got uri: $uri');
          await processIncomingUri(uri, context);
        }
      } on services.PlatformException {
        // Platform messages may fail but we ignore the exception
        log.e('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        log.e('malformed initial uri: $err');
      }
    }
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
      ],
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.darkGradientStartColor,
                Theme.of(context).colorScheme.darkGradientEndColor,
              ],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(flex: 3),
                  const TitleText(),
                  const Spacer(flex: 1),
                  const SubTitle(),
                  const Spacer(flex: 2),
                  const SplashImage(),
                  const Spacer(flex: 3),
                  const LoadingText(),
                  const SizedBox(height: 10),
                  BlocBuilder<SplashCubit, SplashState>(
                    builder: (context, state) {
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: state.loadedValue),
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
      ),
    );
  }
}
