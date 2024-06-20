// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:altme/app/app.dart';
import 'package:altme/bootstrap.dart';
import 'package:altme/theme/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // required when using any plugin. In our case, it's shared_preferences
  WidgetsFlutterBinding.ensureInitialized();

  // Creating an instance of ThemeRepository that will invoke the _init() method
  // and populate the stream controller in the repository.
  final themeRepository = ThemeRepository(
    sharedPreferences: await SharedPreferences.getInstance(),
  );

  await bootstrap(
    () => App(
      flavorMode: FlavorMode.staging,
      themeRepository: themeRepository,
    ),
  );
}
