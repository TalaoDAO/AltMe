import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/enterprise.dart';
import 'package:altme/splash/splash.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  String? _deeplink;

  Future<void> processIncomingUri(Uri? uri) async {
    String beaconData = '';
    bool isBeaconRequest = false;
    late Uri? newUri;
    if (uri.toString().startsWith('${Parameters.universalLink}/oidc4vc?uri=')) {
      newUri = Uri.parse(
        Uri.decodeFull(
          uri
              .toString()
              .substring('${Parameters.universalLink}/oidc4vc?uri='.length),
        ),
      );
    } else {
      newUri = uri;
    }

    if (_deeplink != null && _deeplink == newUri.toString()) {
      return;
    }

    // If the deeplink is already processed, do not process it again.
    _deeplink = newUri.toString();
    Future.delayed(const Duration(seconds: 2), () async {
      _deeplink = null;
    });

    if (newUri.toString().startsWith('${Parameters.universalLink}/dashboard')) {
      await Navigator.pushAndRemoveUntil<void>(
        context,
        DashboardPage.route(),
        (Route<dynamic> route) => route.isFirst,
      );
      return;
    }

    if (newUri.toString().startsWith(Parameters.redirectUri)) {
      await context.read<QRCodeScanCubit>().authorizedFlowStart(newUri!);
      return;
    }

    if (newUri.toString().startsWith('configuration://?')) {
      await context.read<EnterpriseCubit>().requestTheConfiguration(
            uri: newUri!,
            qrCodeScanCubit: context.read<QRCodeScanCubit>(),
          );
      return;
    }

    newUri!.queryParameters.forEach((key, value) async {
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

    if (isBeaconRequest && beaconData != '') {
      unawaited(
        context.read<BeaconCubit>().peerFromDeepLink(beaconData),
      );
    }
    if (isOIDC4VCIUrl(newUri) ||
        isSiopV2OrOidc4VpUrl(newUri) ||
        newUri.toString().startsWith(Parameters.universalLink)) {
      context.read<DeepLinkCubit>().addDeepLink(newUri.toString());
      return;
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
        enterpriseBlocListener,
        ProfileCubitListener,
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
