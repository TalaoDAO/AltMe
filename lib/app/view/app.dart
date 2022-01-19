// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ssi_crypto_wallet/l10n/l10n.dart';
import 'package:ssi_crypto_wallet/splash/view/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFFe15522)),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.green,
          indicator: UnderlineTabIndicator(
            // color for indicator (underline)
            borderSide: BorderSide(color: Colors.brown),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFFe15522),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFFe15522)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFFe15522),
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashPage(),
    );
  }
}
