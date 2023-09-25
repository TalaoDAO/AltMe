import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

    if (uri.toString().startsWith(Parameters.oidc4vcUniversalLink)) {
      final codeForAuthorisedFlow = uri!.queryParameters['code'];
      final state = uri.queryParameters['state'];

      if (codeForAuthorisedFlow == null || state == null) {
        return;
      }
      await dotenv.load();
      final String authorizationUriSecretKey =
          dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

      final jwt = JWT.verify(state, SecretKey(authorizationUriSecretKey));

      final payload = jwt.payload as Map<String, dynamic>;

      final containsAllRequiredKey = payload.containsKey('credentials') &&
          payload.containsKey('codeVerifier') &&
          payload.containsKey('issuer') &&
          payload.containsKey('isEBSIV3');

      if (!containsAllRequiredKey) {
        return;
      }

      final selectedCredentials = payload['credentials'] as List<dynamic>;
      final String codeVerifier = payload['codeVerifier'].toString();
      final String issuer = payload['issuer'].toString();
      final bool isEBSIV3 = payload['isEBSIV3'] as bool;

      await context.read<QRCodeScanCubit>().addCredentialsInLoop(
            selectedCredentials: selectedCredentials,
            userPin: null,
            issuer: issuer,
            preAuthorizedCode: null,
            isEBSIV3: isEBSIV3,
            codeForAuthorisedFlow: codeForAuthorisedFlow,
            codeVerifier: codeVerifier,
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
