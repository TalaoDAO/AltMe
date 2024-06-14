import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);
  test('can access AppTheme', () {
    expect(AppTheme, isNotNull);
  });

  test('CustomColorScheme Test', () {
    const colorScheme = ColorScheme.dark();

    expect(colorScheme.error, const Color(0xFFFF0045));
    expect(colorScheme.onTertiary, const Color(0xFF00B267));
    expect(colorScheme.error, const Color(0xFFFF0045));
    expect(colorScheme.onErrorContainer, const Color(0xFFFF5F0A));
    expect(colorScheme.primary, const Color(0xFF2C7DF7));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xFFD1CCE3));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xFF86809D));
    expect(colorScheme.secondary, const Color(0xFF5F556F));
    expect(colorScheme.surface, const Color(0xff271C38));
    expect(colorScheme.surface, const Color(0xFF251F38));
    expect(colorScheme.surface, const Color(0xFF322643));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xFFA79ABA));
    expect(colorScheme.primary, const Color(0xFF0045FF));
    expect(colorScheme.onTertiary, const Color(0xFF00B267));
    expect(colorScheme.onSurface.withOpacity(0.12), equals(Colors.grey[200]));
    expect(colorScheme.onSurface, equals(Colors.white));
    expect(Colors.transparent, equals(Colors.transparent));
    expect(colorScheme.onSurface.withOpacity(0.12), const Color(0xFF6A5F7B));
    expect(colorScheme.onSurface.withOpacity(0.38), const Color(0xFF000000));
    expect(colorScheme.surface, const Color(0xff0A0F19));
    expect(colorScheme.surface, const Color(0xff25095B));
    expect(Colors.transparent, equals(Colors.transparent));
    expect(colorScheme.primary, const Color(0xFF6600FF));
    expect(colorScheme.onPrimary, equals(Colors.white));
    expect(colorScheme.surface, const Color(0xff25095B));
    expect(colorScheme.surface, equals(colorScheme.surface));
    expect(
      colorScheme.surface.withOpacity(0.07),
      equals(const Color(0xff707070).withOpacity(0.07)),
    );
    expect(colorScheme.surface, const Color(0xff232630));
    expect(colorScheme.onSurface, equals(Colors.white));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xff86809D));
    expect(colorScheme.onSurface, const Color(0xffF1EFF8));
    expect(colorScheme.surface, equals(colorScheme.surface));
    expect(colorScheme.surface, const Color(0xff0B0514));
    expect(colorScheme.onSurface.withOpacity(0.12), const Color(0xFFDDCEF4));
    expect(
      colorScheme.onSurface.withOpacity(0.2),
      const Color(0xFFFFFFFF).withOpacity(0.2),
    );
    expect(colorScheme.onSurface, equals(Colors.white));
    expect(colorScheme.onSurface, equals(Colors.white));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xFFD1CCE3));
    expect(colorScheme.primary, const Color(0xff517bff));
    expect(colorScheme.onSurface, equals(Colors.white));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xFF8B8C92));
    expect(colorScheme.onSurface, const Color(0xFF212121));
    expect(colorScheme.onSurface.withOpacity(0.12), const Color(0xFF424242));
    expect(
      colorScheme.primary.withOpacity(0.05),
      equals(const Color(0xff3700b3).withOpacity(0.05)),
    );
    expect(colorScheme.onErrorContainer, const Color(0xFFFFB83D));
    expect(colorScheme.onSurface, const Color(0xFF212121));
    expect(colorScheme.onTertiary, equals(Colors.green));
    expect(colorScheme.onErrorContainer, equals(Colors.orange));
    expect(colorScheme.error, equals(Colors.red));
    expect(colorScheme.onSurface.withOpacity(0.38), const Color(0xFF424242));
    expect(colorScheme.error, equals(Colors.red));
    expect(colorScheme.onErrorContainer, equals(Colors.yellow));
    expect(colorScheme.outline, equals(Colors.cyan));
    expect(colorScheme.onTertiary, equals(Colors.green));
    expect(colorScheme.surface, const Color(0xff2B1C48));
    expect(
      colorScheme.shadow.withOpacity(0.16),
      const Color(0xff000000).withOpacity(0.16),
    );
    expect(colorScheme.primary, const Color(0xff430F91));
    expect(colorScheme.onSurface, const Color(0xffF5F5F5));
    expect(colorScheme.secondaryContainer, const Color(0xFF280164));
    expect(colorScheme.surface, const Color(0xFF211F33));
    expect(
      colorScheme.onSurface.withOpacity(0.15),
      equals(Colors.grey.withOpacity(0.15)),
    );
    expect(colorScheme.primary, const Color(0xff18ACFF));
    expect(colorScheme.primaryContainer, const Color(0xff6600FF));
    expect(colorScheme.onSurface.withOpacity(0.12), const Color(0xff524B67));
    expect(colorScheme.surface, const Color(0xff322643));
    expect(colorScheme.surface, const Color(0xff322643));
    expect(colorScheme.onSurface, const Color(0xffD1CCE3));
    expect(colorScheme.onSurface, const Color(0xffFFFFFF));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xFF616161));
    expect(colorScheme.onSurface, const Color(0xFF212121));
    expect(colorScheme.onTertiary, const Color(0xFF08B530));
    expect(colorScheme.error, const Color(0xFFFF0045));
    expect(colorScheme.onSurface.withOpacity(0.6), const Color(0xff86809D));
    expect(colorScheme.surface, const Color(0xFF211F33));
  });
}
