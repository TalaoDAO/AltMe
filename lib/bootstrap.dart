// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:altme/app/shared/enum/flavor.dart';
import 'package:altme/app/view/app.dart';
import 'package:altme/theme/theme_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
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

Future<void> bootstrap(FlavorMode flavor) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(() async {
    // required when using any plugin. In our case, it's shared_preferences
    WidgetsFlutterBinding.ensureInitialized();

    // Creating an instance of ThemeRepository that will invoke the _init()
    // method
    // and populate the stream controller in the repository.
    final themeRepository = ThemeRepository(
      sharedPreferences: await SharedPreferences.getInstance(),
    );

    await initSecureStorage;

      /// Disable Http google font
      // GoogleFonts.config.allowRuntimeFetching = false;

    await Dartez().init();
    Bloc.observer = AppBlocObserver();
    runApp(App(flavorMode: flavor, themeRepository: themeRepository));
  }, (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
}
