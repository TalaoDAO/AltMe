// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:altme/app/app.dart';
import 'package:altme/bootstrap.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  bootstrap(
    () => DevicePreview(
      builder: (context) => const App(
        flavorMode: FlavorMode.staging,
      ),
    ),
  );
}
