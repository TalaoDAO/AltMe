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
          labelColor: Color(0xFFff225d),
          unselectedLabelColor: Color(0xFFffc422),
          indicator: UnderlineTabIndicator(
            // color for indicator (underline)
            borderSide: BorderSide(color: Color(0xFFff225d)),
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
        appBarTheme: const AppBarTheme(color: Color(0xFF007cb7)),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xFFdc1ea9),
          unselectedLabelColor: Color(0xEE7b49e8),
          indicator: UnderlineTabIndicator(
            // color for indicator (underline)
            borderSide: BorderSide(color: Color(0xFFdc1ea9)),
          ),
        ),
        colorScheme: ColorScheme(
          primary: const Color(0xFF232d55),
          primaryVariant: const Color(0xFF007d50),
          secondary: const Color(0xFFffdc05),
          secondaryVariant: const Color(0xFF007cb7),
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
