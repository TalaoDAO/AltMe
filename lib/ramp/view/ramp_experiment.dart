import 'dart:convert';

import 'package:altme/app/shared/widget/button/button.dart';
import 'package:flutter/material.dart';

import 'package:ramp_flutter/ramp_flutter.dart';

class RampFlutterApp extends StatefulWidget {
  const RampFlutterApp({Key? key}) : super(key: key);

  static Route route({required String walletAddress}) {
    return MaterialPageRoute<void>(
      builder: (_) => const RampFlutterApp(),
      settings: const RouteSettings(name: '/RampFlutterApp'),
    );
  }

  @override
  State<RampFlutterApp> createState() => _RampFlutterAppState();
}

class _RampFlutterAppState extends State<RampFlutterApp> {
  final Configuration configuration = Configuration();

  // final List<String> _environments = [
  //   'https://ri-widget-dev.firebaseapp.com',
  //   'https://ri-widget-staging.firebaseapp.com',
  //   'https://buy.ramp.network',
  // ];

  @override
  void initState() {
    _presentRamp();
    super.initState();
  }

  void _presentRamp() {
    configuration.fiatCurrency = 'EUR';
    configuration.fiatValue = '15';
    configuration.defaultAsset = 'ETH';
    configuration.userAddress = '0x4b7f8e04b82ad7f9e4b4cc9e1f81c5938e1b719f';
    configuration.hostAppName = 'Ramp Flutter';
    //configuration.hostApiKey = '//';
    //configuration.deepLinkScheme = 'altme';
  }

  void onPurchaseCreated(Purchase purchase, String token, String url) {
    print(purchase.toString());
    print(token);
    print(url);
  }

  void onRampFailed() {
    print('onRampFailed');
  }

  void onRampClosed() {
    print('onRampClosed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MyElevatedButton(
          text: 'Show Ramp',
          onPressed: () {
            print(jsonEncode(configuration.toMap()));
            RampFlutter.showRamp(
              configuration,
              onPurchaseCreated,
              onRampFailed,
              onRampClosed,
            );
          },
        ),
      ),
    );
  }
}
