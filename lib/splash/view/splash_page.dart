import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jose/jose.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;
import 'package:secure_storage/secure_storage.dart';
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
          final String scannedResponse = uri.toString();
          final client = DioClient(Urls.issuerBaseUrl, Dio());
          if (scannedResponse.startsWith('openid://initiate_issuance?')) {
            // convert String from QR code into Uri
            final uri = Uri.parse(scannedResponse);
            final String conformance = uri.queryParameters['conformance']!;
            final credential_type = uri.queryParameters['credential_type']!;
            final issuer = uri.queryParameters['issuer']!;
            const redirectUri = 'app.altme.io/app/download/callback';
            // final redirectUri = 'app.altme.io';
            final headers = {
              'Conformance': conformance,
              'Content-Type': 'application/json'
            };
            const authorizeUrl =
                'https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/authorize';

            final my_request = <String, dynamic>{
              'scope': 'openid',
              'client_id': redirectUri,
              'response_type': 'code',
              'authorization_details': jsonEncode([
                {
                  'type': 'openid_credential',
                  'credential_type': credential_type,
                  'format': 'jwt_vc'
                }
              ]),
              'redirect_uri': redirectUri,
              'state': '1234'
            };
            String code = '210901fc2fc063e9a30a';

            try {
              final Uri authorizationUri = Uri(
                scheme: 'https',
                path: '/conformance/v2/issuer-mock/authorize',
                queryParameters: my_request,
                host: 'api-conformance.ebsi.eu',
              );
              final dynamic authorizationResponse = await client.get(
                  authorizeUrl,
                  headers: headers,
                  queryParameters: my_request);
              print('got authorization');
              // Should get code from authorization response or this callback system
              /// we should receive something through deepLink ?

            } catch (e) {
              if (e is NetworkException) {
                if (e.data != null) {
                  if (e.data['detail'] != null) {
                    final String error = e.data['detail'] as String;
                    final codeSplit = error.split('code=');
                    code = codeSplit[1];
                  }
                }
              }
              print('Lokks like wa can get code from here');
            }

            /// getting token
            final tokenHeaders = <String, dynamic>{
              'Conformance': conformance,
              'Content-Type': 'application/x-www-form-urlencoded'
            };
            final String tokenUrl =
                'https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/token';

            final tokenData = <String, dynamic>{
              'code': code,
              'grant_type': 'authorization_code',
              'redirect_uri': redirectUri
            };
            String accessToken = '';
            String cNonce = '';
            try {
              final dynamic tokenResponse = await client.post(
                tokenUrl,
                headers: tokenHeaders,
                data: tokenData,
              );
              accessToken = tokenResponse['access_token'] as String;
              cNonce = tokenResponse['c_nonce'] as String;
            } catch (e) {
              print('what the !!');
            }

            /// preparation before getting credential
            final keyDict = {
              'crv': 'P-256',
              'd': 'ZpntMmvHtDxw6przKSJY-zOHMrEZd8C47D3yuqAsqrw',
              'kty': 'EC',
              'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
              'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
            };

            final keyJwk = {
              'crv': 'P-256',
              'kty': 'EC',
              'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
              'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
            };

            final verifierKey = JsonWebKey.fromJson(keyDict);
            final alg = keyDict['crv'] == 'P-256' ? 'ES256' : 'ES256K';
            final did =
                'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya';
            final kid =
                'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya#lD7U7tcVLZWmqECJYRyGeLnDcU4ETX3reBN3Zdd0iTU';

            final proofHeader = {
              'typ': 'JWT',
              'alg': alg,
              'jwk': keyJwk,
              'kid': kid
            };
            final payload = {
              'iss': did,
              'nonce': cNonce,
              'iat': DateTime.now().microsecondsSinceEpoch,
              'aud': issuer
            };
            final claims = new JsonWebTokenClaims.fromJson(payload);
// create a builder, decoding the JWT in a JWS, so using a
            // JsonWebSignatureBuilder
            final builder = new JsonWebSignatureBuilder();
// set the content
            builder.jsonContent = claims.toJson();

            builder.setProtectedHeader('typ', 'JWT');
            builder.setProtectedHeader('alg', alg);
            builder.setProtectedHeader('jwk', keyJwk);
            builder.setProtectedHeader('kid', kid);

            // add a key to sign, can only add one for JWT
            builder.addRecipient(
              verifierKey,
              algorithm: alg,
            );
            // build the jws
            var jws = builder.build();

            // output the compact serialization
            print('jwt compact serialization: ${jws.toCompactSerialization()}');
            final jwt = jws.toCompactSerialization();

            const String credentialUrl =
                'https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/credential';
            final credentialHeaders = <String, dynamic>{
              'Conformance': conformance,
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            };

            final credentialData = <String, dynamic>{
              'type': credential_type,
              'format': 'jwt_vc',
              'proof': {'proof_type': 'jwt', 'jwt': jwt}
            };

            final dynamic credentialResponse = await client.post(credentialUrl,
                headers: credentialHeaders, data: credentialData);
            final storage = getSecureStorage;
            await storage.set('ebsiCredential', jsonEncode(credentialResponse));
            await storage.set('conformance', conformance);
            return;
          } else if (scannedResponse
              .startsWith('openid://?scope=openid&response_type=id_token')) {
            final keyDict = {
              'crv': 'P-256',
              'd': 'ZpntMmvHtDxw6przKSJY-zOHMrEZd8C47D3yuqAsqrw',
              'kty': 'EC',
              'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
              'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
            };

            final keyJwk = {
              'crv': 'P-256',
              'kty': 'EC',
              'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
              'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
            };

            final verifierKey = JsonWebKey.fromJson(keyDict);
            final alg = keyDict['crv'] == 'P-256' ? 'ES256' : 'ES256K';
            final did =
                'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya';
            final kid =
                'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya#lD7U7tcVLZWmqECJYRyGeLnDcU4ETX3reBN3Zdd0iTU';
            final storage = getSecureStorage;
            final conformance = await storage.get('conformance') as String;
            final credentialJson =
                await storage.get('ebsiCredential') as String;
            final dynamic credentialResponse = jsonDecode(credentialJson);
            final String credential =
                credentialResponse['credential'] as String;
            // decode the jwt, note: this constructor can only be used for JWT inside JWS
            // structures
            final jwt = new JsonWebToken.unverified(credential);
            final claims = jwt.claims;
            final String audience = claims['iss'] as String;
            final uri = Uri.parse(scannedResponse);
            final redirectUri = uri.queryParameters['redirect_uri'];
            final clientId = uri.queryParameters['client_id'];
            final nonce = uri.queryParameters['nonce'];
            final claimsFromUri = uri.queryParameters['claims'];

            /// build id token
            final payload = {
              'iat': DateTime.now().microsecondsSinceEpoch,
              'aud': audience,
              'exp': DateTime.now().microsecondsSinceEpoch + 1000,
              'sub': did,
              'iss': 'https://self-issued.me/v2',
              'nonce': nonce,
              '_vp_token': {
                'presentation_submission': {
                  'definition_id': 'conformance_mock_vp_request',
                  'id': 'VA presentation Talao',
                  'descriptor_map': [
                    {
                      'id': 'conformance_mock_vp',
                      'format': 'jwt_vp',
                      'path': r'$',
                    }
                  ]
                }
              }
            };
            final verifierClaims = new JsonWebTokenClaims.fromJson(payload);
// create a builder, decoding the JWT in a JWS, so using a
            // JsonWebSignatureBuilder
            final builder = new JsonWebSignatureBuilder();
// set the content
            builder.jsonContent = verifierClaims.toJson();

            builder.setProtectedHeader('typ', 'JWT');
            builder.setProtectedHeader('alg', alg);
            builder.setProtectedHeader('jwk', keyJwk);
            builder.setProtectedHeader('kid', kid);

            // add a key to sign, can only add one for JWT
            builder.addRecipient(
              verifierKey,
              algorithm: alg,
            );
            // build the jws
            final jws = builder.build();

            // output the compact serialization
            final verifierIdJwt = jws.toCompactSerialization();

            /// build vp token
            final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
            final vpTokenPayload = {
              'iat': iat,
              'jti': 'http://example.org/presentations/talao/01',
              'nbf': iat - 10,
              'aud': audience,
              'exp': iat + 1000,
              'sub': did,
              'iss': did,
              'vp': {
                '@context': ['https://www.w3.org/2018/credentials/v1'],
                'id': 'http://example.org/presentations/talao/01',
                'type': ['VerifiablePresentation'],
                'holder': did,
                'verifiableCredential': [credential]
              },
              'nonce': nonce
            };
            final vpVerifierClaims =
                new JsonWebTokenClaims.fromJson(vpTokenPayload);
// create a builder, decoding the JWT in a JWS, so using a
            // JsonWebSignatureBuilder
            final vpBuilder = new JsonWebSignatureBuilder();
// set the content
            vpBuilder.jsonContent = vpVerifierClaims.toJson();

            vpBuilder.setProtectedHeader('typ', 'JWT');
            vpBuilder.setProtectedHeader('alg', alg);
            vpBuilder.setProtectedHeader('jwk', keyJwk);
            vpBuilder.setProtectedHeader('kid', kid);

            // add a key to sign, can only add one for JWT
            vpBuilder.addRecipient(
              verifierKey,
              algorithm: alg,
            );
            // build the jws
            final vpJws = vpBuilder.build();

            // output the compact serialization
            final verifierVpJwt = vpJws.toCompactSerialization();

            final responseHeaders = {
              'Conformance': conformance,
              'Content-Type': 'application/x-www-form-urlencoded',
            };

            final responseData = <String, dynamic>{
              'id_token': verifierIdJwt,
              'vp_token': verifierVpJwt
            };
            final dynamic verifierResponse = await client.post(redirectUri!,
                headers: responseHeaders, data: responseData);
            return;
          }

          String beaconData = '';
          bool isBeaconRequest = false;
          uri?.queryParameters.forEach((key, value) async {
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
            if (uri.scheme == 'openid') {
              final Dio client = Dio();

              final String credentialType =
                  Ebsi(client).getCredentialRequest(uri.toString());
              context.read<DeepLinkCubit>().addDeepLink(credentialType);
              final ssiKey = await secure_storage.getSecureStorage
                  .get(SecureStorageKeys.ssiKey);
              if (ssiKey != null) {
                await context.read<QRCodeScanCubit>().openidDeepLink();
              }
            }
          });
          if (isBeaconRequest && beaconData != '') {
            context.read<BeaconCubit>().peerFromDeepLink(beaconData);
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
