// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home/cubit/home_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:dartez/dartez.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final log = getLogger('Workmanager');
    switch (task) {
      case 'getPassBaseStatusBackground':
        if (inputData!['did'] != null) {
          Timer.periodic(const Duration(seconds: 20), (timer) async {
            final String did = inputData['did'] as String;
            final secureStorageProvider = secure_storage.getSecureStorage;
            final String? passbaseStatusFromStorage =
                await secureStorageProvider.get(
              SecureStorageKeys.passBaseStatus,
            );
            log.i(
              'isolate passbaseStatusFrom storage: $passbaseStatusFromStorage',
            );

            final PassBaseStatus oldPassBaseStatus =
                getPassBaseStatusFromString(
              passbaseStatusFromStorage,
            );

            if (oldPassBaseStatus != PassBaseStatus.approved) {
              try {
                final PassBaseStatus newPassBaseStatus =
                    await getPassBaseStatusFromAPI(did);
                log.i('passbase isolate newPassBaseStatus: $newPassBaseStatus');

                switch (newPassBaseStatus) {
                  case PassBaseStatus.approved:
                  case PassBaseStatus.declined:
                  case PassBaseStatus.verified:
                    await secureStorageProvider.set(
                      SecureStorageKeys.passBaseStatus,
                      newPassBaseStatus.name,
                    );
                    timer.cancel();
                    break;
                  case PassBaseStatus.pending:
                    await secureStorageProvider.set(
                      SecureStorageKeys.passBaseStatus,
                      newPassBaseStatus.name,
                    );
                    break;
                  case PassBaseStatus.undone:
                    break;
                  case PassBaseStatus.complete:
                    break;
                  case PassBaseStatus.idle:
                    break;
                }
              } catch (e) {
                log.e(e.toString());
                await secureStorageProvider.set(
                  SecureStorageKeys.passBaseStatus,
                  PassBaseStatus.idle.name,
                );
                timer.cancel();
              }
            }
          });
        }
        break;
    }

    return Future.value(true);
  });
}

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

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotification().init();

  await PassbaseSDK.initialize(
    publishableApiKey: AltMeStrings.passBasePublishableApiKey,
  );

  /// Disable Http google font
  // GoogleFonts.config.allowRuntimeFetching = false;

  await Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode:
        false, // If enabled it will post a notification whenever the task is
    // running. Handy for debugging tasks
  );

  await Dartez().init();

  /// PolygonId SDK initialization
  // await PolygonId().init();

  await runZonedGuarded(
    () async {
      Bloc.observer = AppBlocObserver();
      runApp(await builder());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
