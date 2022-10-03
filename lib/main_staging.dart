// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/bootstrap.dart';

void main() {
  bootstrap(() => const App(flavorMode: FlavorMode.staging));
}
