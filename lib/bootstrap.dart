// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:altme/app/shared/enum/flavor.dart';
import 'package:altme/app/shared/protocol_trace/start_protocol_trace.dart';
import 'package:altme/app/view/app.dart';
import 'package:altme/theme/theme_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, ${change.runtimeType})');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Adds the licences of the bundled fonts to the software licence page.
void registerFontLicenses() {
  const fonts = {
    'Manrope': 'assets/fonts/Manrope-OFL.txt',
    'Open Sans': 'assets/fonts/OpenSans-OFL.txt',
  };
  LicenseRegistry.addLicense(() async* {
    for (final font in fonts.entries) {
      yield LicenseEntryWithLineBreaks([
        font.key,
      ], await rootBundle.loadString(font.value));
    }
  });
}

Future<void> bootstrap(FlavorMode flavor) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(() async {
    // required when using any plugin. In our case, it's shared_preferences
    WidgetsFlutterBinding.ensureInitialized();
    registerFontLicenses();

    // Creating an instance of ThemeRepository that will invoke the _init()
    // method
    // and populate the stream controller in the repository.
    final themeRepository = ThemeRepository(
      sharedPreferences: await SharedPreferences.getInstance(),
    );

    await initSecureStorage;

    // Only if developer mode is on; before anything opens an HttpClient, so
    // the wallet provider onboarding at startup is traced too.
    await startProtocolTrace();

    Bloc.observer = AppBlocObserver();
    runApp(App(flavorMode: flavor, themeRepository: themeRepository));
  }, (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
}
