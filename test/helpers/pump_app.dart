// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:altme/app/shared/shared.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_ui/wallet_ui.dart';

extension PumpApp on WidgetTester {
  /// Pumps [widget] in a [MaterialApp]. [wrapApp] puts something above the
  /// app, like the providers of the real app, which routes pushed from
  /// [widget] can see. [navigatorObservers] watch the app's navigator.
  Future<void> pumpApp(
    Widget widget, {
    Widget Function(Widget app)? wrapApp,
    List<NavigatorObserver> navigatorObservers = const [],
    Brightness brightness = Brightness.light,
  }) {
    final app = MaterialApp(
      navigatorObservers: navigatorObservers,
      theme: brightness == Brightness.light
          ? WalletTheme.light(Parameters.walletUiConfig)
          : WalletTheme.dark(Parameters.walletUiConfig),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: widget,
    );
    return pumpWidget(wrapApp == null ? app : wrapApp(app));
  }
}
