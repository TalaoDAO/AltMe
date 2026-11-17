import 'package:altme/app/shared/shared.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_ui/wallet_ui.dart';

void main() {
  Color brand(ThemeData theme) => theme.colorScheme.primary;

  group('AppTheme.parsePrimaryColor', () {
    test('parses a #RRGGBB value', () {
      expect(AppTheme.parsePrimaryColor('#1EAADC'), const Color(0xFF1EAADC));
    });

    test('gives null for no value, an empty value or invalid hex', () {
      expect(AppTheme.parsePrimaryColor(null), isNull);
      expect(AppTheme.parsePrimaryColor(''), isNull);
      expect(AppTheme.parsePrimaryColor('#12'), isNull);
      expect(AppTheme.parsePrimaryColor('#GGGGGG'), isNull);
      expect(AppTheme.parsePrimaryColor('1EAADC'), isNull);
    });
  });

  group('AppTheme.themeData', () {
    test('without an override uses the wallet_ui brand colour', () {
      final expected = WalletTheme.light(Parameters.walletUiConfig);
      expect(
        brand(AppTheme.themeData(Brightness.light, null)),
        brand(expected),
      );
    });

    test('an invalid override falls back to the default brand colour', () {
      expect(
        brand(AppTheme.themeData(Brightness.light, 'nope')),
        brand(AppTheme.themeData(Brightness.light, null)),
      );
    });

    test('a valid override changes the brand colour', () {
      expect(
        brand(AppTheme.themeData(Brightness.light, '#AA0000')),
        isNot(brand(AppTheme.themeData(Brightness.light, null))),
      );
    });

    test('is memoised per brightness and override', () {
      expect(
        identical(
          AppTheme.themeData(Brightness.dark, '#AA0000'),
          AppTheme.themeData(Brightness.dark, '#aa0000'),
        ),
        isTrue,
      );
      expect(
        identical(
          AppTheme.themeData(Brightness.light, null),
          AppTheme.themeData(Brightness.dark, null),
        ),
        isFalse,
      );
    });

    test('uses the bundled font families', () {
      final theme = AppTheme.themeData(Brightness.light, null);
      expect(theme.textTheme.bodyMedium?.fontFamily, 'Open Sans');
    });
  });

  group('AppTheme.overlayStyle', () {
    test('follows the resolved brightness', () {
      final light = AppTheme.overlayStyle(Brightness.light);
      final dark = AppTheme.overlayStyle(Brightness.dark);
      expect(light.statusBarIconBrightness, Brightness.dark);
      expect(dark.statusBarIconBrightness, Brightness.light);
      expect(light.systemNavigationBarColor, const Color(0xFFFFFFFF));
      expect(dark.systemNavigationBarColor, const Color(0xFF0F0F0F));
    });
  });
}
