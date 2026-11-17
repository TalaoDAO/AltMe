import 'package:altme/app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_ui/wallet_ui.dart';

/// Builds the app themes from the `wallet_ui` design system.
abstract final class AppTheme {
  static final _themes = <(Brightness, Color?), ThemeData>{};

  /// Parses a profile `primaryColor` (`#RRGGBB`) into a colour. Anything else
  /// gives `null`, so the design system keeps its own brand colour.
  static Color? parsePrimaryColor(String? hex) {
    if (hex == null || !RegExp(r'^#[0-9a-fA-F]{6}').hasMatch(hex)) return null;
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /// The theme for [brightness] and the profile's [primaryColor].
  ///
  /// Building a `wallet_ui` theme derives colours and allocates every
  /// component theme, so the result is kept per (brightness, override).
  static ThemeData themeData(Brightness brightness, String? primaryColor) {
    final override = parsePrimaryColor(primaryColor);
    return _themes.putIfAbsent((brightness, override), () {
      final config = WalletUiConfig(
        fonts: Parameters.walletUiConfig.fonts,
        icons: Parameters.walletUiConfig.icons,
        primaryColorOverride: override,
      );
      return brightness == Brightness.light
          ? WalletTheme.light(config)
          : WalletTheme.dark(config);
    });
  }

  /// The status and navigation bar style for the resolved [brightness]:
  /// light icons on a dark page and the other way round.
  static SystemUiOverlayStyle overlayStyle(Brightness brightness) {
    final background = themeData(brightness, null).scaffoldBackgroundColor;
    final iconBrightness = brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: iconBrightness,
      statusBarBrightness: brightness,
      systemNavigationBarColor: background,
      systemNavigationBarIconBrightness: iconBrightness,
    );
  }
}
