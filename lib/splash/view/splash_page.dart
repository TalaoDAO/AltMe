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
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

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
  late AppLinks _appLinks;
  StreamSubscription<Uri?>? _linkSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await context.read<SplashCubit>().initialiseApp();
        await initDeepLinks();
      },
    );
    super.initState();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (context.read<SplashCubit>().state.status ==
            SplashStatus.authenticated) {
          timer.cancel();
          processIncomingUri(uri);
        }
      });
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  bool isPolygonFunctionCalled = false;

  String? _deeplink;

  Future<void> processIncomingUri(Uri? uri) async {
    final l10n = context.l10n;
    String beaconData = '';
    bool isBeaconRequest = false;

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
        final ssiKey =
            await secure_storage.getSecureStorage.get(SecureStorageKeys.ssiKey);
        if (ssiKey != null) {
          context.read<DeepLinkCubit>().addDeepLink(url);
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
      return;
    }

    if (isBeaconRequest && beaconData != '') {
      unawaited(
        context.read<BeaconCubit>().peerFromDeepLink(beaconData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
