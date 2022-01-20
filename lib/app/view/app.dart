// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ssi_crypto_wallet/app/cubit/theme_mode_cubit.dart';
import 'package:ssi_crypto_wallet/l10n/l10n.dart';
import 'package:ssi_crypto_wallet/splash/view/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeModeCubit(),
      child: const MaterialAppDefinition(),
    );
  }
}

class MaterialAppDefinition extends StatelessWidget {
  const MaterialAppDefinition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFFFF5722)),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xFF00D30F),
          unselectedLabelColor: Color(0xFFB1D400),
          indicator: UnderlineTabIndicator(
            // color for indicator (underline)
            borderSide: BorderSide(color: Color(0xFF00D30F)),
          ),
        ),
        colorScheme: ColorScheme(
          primary: const Color(0xFF232d55),
          primaryVariant: const Color(0xFF007d50),
          secondary: const Color(0xFFffdc05),
          secondaryVariant: const Color(0xFFFF5722),
          background: Colors.grey[700]!,
          brightness: Brightness.light,
          error: Colors.red,
          onBackground: Colors.white,
          onError: Colors.black,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          surface: Colors.grey[800]!,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF1eaadc)),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xEEffdc05),
          unselectedLabelColor: Colors.white,
          indicator: UnderlineTabIndicator(
            // color for indicator (underline)
            borderSide: BorderSide(color: Color(0xEEffdc05)),
          ),
        ),
        colorScheme: ColorScheme(
          primary: const Color(0xFF232d55),
          primaryVariant: const Color(0xFF007d50),
          secondary: const Color(0xFFffdc05),
          secondaryVariant: const Color(0xFF1eaadc),
          background: Colors.grey[700]!,
          brightness: Brightness.dark,
          error: Colors.red,
          onBackground: Colors.white,
          onError: Colors.black,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          surface: Colors.grey[800]!,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: context.select((ThemeModeCubit cubit) => cubit.state),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashPage(),
    );
  }
}
