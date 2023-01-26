import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/ebsi/initiate_ebsi_credential_issuance.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jose/jose.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashView();
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
    final log = getLogger('DeepLink - _handleIncomingLinks');

    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen(
        (Uri? uri) async {
          if (!mounted) return;
          log.i('got uri: $uri');
          final url = '${uri!.scheme}://${uri.authority}${uri.path}';

          if (url == Parameters.ebsiUniversalLink) {
            print('listen');
            final client = Dio();
            final ebsi = Ebsi(client);
            final dynamic encodedCredentialFromEbsi =
                await ebsi.getCredential(uri);
            var jws = JsonWebSignature.fromCompactSerialization(
                encodedCredentialFromEbsi['credential'] as String);

            final credentialFromEbsi =
                jws.unverifiedPayload.jsonContent['vc'] as Map<String, dynamic>;
            final Map<String, dynamic> newCredential =
                Map<String, dynamic>.from(credentialFromEbsi);
            newCredential['credentialPreview'] = credentialFromEbsi;
            final String credentialSchema =
                uri.queryParameters['credential_type'] ?? '';
            final issuerAndCode = uri.queryParameters['issuer'];
            final issuerAndCodeUri = Uri.parse(issuerAndCode!);
            final issuer =
                '${issuerAndCodeUri.scheme}://${issuerAndCodeUri.authority}${issuerAndCodeUri.path}';

            final CredentialManifest credentialManifest =
                await getCredentialManifest(
              Dio(),
              issuer,
              credentialSchema,
            );
            if (credentialManifest.outputDescriptors!.isNotEmpty) {
              newCredential['credential_manifest'] = CredentialManifest(
                credentialManifest.id,
                credentialManifest.issuedBy,
                credentialManifest.outputDescriptors,
                credentialManifest.presentationDefinition,
              ).toJson();
            }

            final credentialModel = CredentialModel.copyWithData(
              oldCredentialModel: CredentialModel.fromJson(
                newCredential,
              ),
              newData: credentialFromEbsi,
              activities: [Activity(acquisitionAt: DateTime.now())],
            );
            // insert the credential in the wallet
            await context
                .read<WalletCubit>()
                .insertCredential(credential: credentialModel);
          } else {
            String beaconData = '';
            bool isBeaconRequest = false;
            uri.queryParameters.forEach((key, value) async {
              if (key == 'uri') {
                final url = value.replaceAll(RegExp(r'ß^\"|\"$'), '');
                context.read<DeepLinkCubit>().addDeepLink(url);
                final ssiKey = await secure_storage.getSecureStorage
                    .get(SecureStorageKeys.ssiKey);
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
              if (uri.scheme == 'openid' &&
                  uri.authority == 'initiate_issuance') {
                final DioClient client = DioClient('', Dio());
                await initiateEbsiCredentialIssuance(uri.toString(), client);
              }
            });
            if (isBeaconRequest && beaconData != '') {
              context.read<BeaconCubit>().peerFromDeepLink(beaconData);
            }
          }
        },
        onError: (Object err) {
          if (!mounted) return;
          log.e('got err: $err');
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
    final log = getLogger('DeepLink - _handleInitialUri');
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
          String beaconData = '';
          bool isBeaconRequest = false;
          uri.queryParameters.forEach((key, value) {
            if (key == 'uri') {
              /// add uri to deepLink cubit
              final url = value.replaceAll(RegExp(r'^\"|\"$'), '');
              context.read<DeepLinkCubit>().addDeepLink(url);
            }
            if (key == 'type' && value == 'tzip10') {
              isBeaconRequest = true;
            }
            if (key == 'data') {
              beaconData = value;
            }
          });
          if (isBeaconRequest && beaconData != '') {
            unawaited(context.read<BeaconCubit>().peerFromDeepLink(beaconData));
          }
        }
        if (!mounted) return;
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
        scanBlocListener,
        qrCodeBlocListener,
        beaconBlocListener,
        walletConnectBlocListener,
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
                children: const [
                  Spacer(flex: 1),
                  TitleText(),
                  Spacer(flex: 1),
                  SubTitle(),
                  Spacer(flex: 3),
                  SplashImage(),
                  Spacer(flex: 10),
                  LoadingText(),
                  SizedBox(height: 10),
                  LoadingProgress(),
                  Spacer(flex: 7),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
