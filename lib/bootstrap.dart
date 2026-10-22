// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:altme/app/logger/logger.dart';
import 'package:altme/app/shared/enum/flavor.dart';
import 'package:altme/app/shared/protocol_trace/start_protocol_trace.dart';
import 'package:altme/app/view/app.dart';
import 'package:altme/theme/theme_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
    unawaited(Sentry.captureException(error, stackTrace: stackTrace));
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FlavorMode flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  // The DSN comes from the bundled `.env`; without one Sentry stays disabled.
  try {
    await dotenv.load();
  } catch (_) {}

  // SentryFlutter.init wires up FlutterError.onError and uncaught async
  // error capturing itself; it chains to any previously set
  // FlutterError.onError, so framework errors are still logged to the console.
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.maybeGet('SENTRY_DSN') ?? '';
      options.environment = flavor.name;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      attachSentryLogListener();

      // Required when using any plugin. In our case, it's shared_preferences.
      // Creating an instance of ThemeRepository will invoke the _init()
      // method and populate the stream controller in the repository.
      final themeRepository = ThemeRepository(
        sharedPreferences: await traceStartup(
          'shared_preferences',
          SharedPreferences.getInstance,
        ),
      );

      await traceStartup('secure storage check', () => initSecureStorage);

      // Debug builds only; before anything opens an HttpClient, so the wallet
      // provider onboarding at startup is traced too.
      await traceStartup('protocol trace', startProtocolTrace);

      /// Disable Http google font
      GoogleFonts.config.allowRuntimeFetching = true;

      Bloc.observer = AppBlocObserver();
      runApp(App(flavorMode: flavor, themeRepository: themeRepository));

      final firstFrame = Completer<void>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        firstFrame.complete();
      });
      unawaited(
        traceStartup(
          'first frame',
          () => firstFrame.future,
        ).then((_) => Sentry.captureMessage('Startup reached the first frame')),
      );
    },
  );
}
