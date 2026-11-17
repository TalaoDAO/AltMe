import 'package:altme/theme/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const key = '__theme_persistence_key__';

  Future<ThemeMode> firstTheme(Map<String, Object> stored) async {
    SharedPreferences.setMockInitialValues(stored);
    final repository = ThemeRepository(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
    addTearDown(repository.dispose);
    return repository.getTheme().first;
  }

  group('ThemeRepository', () {
    test('a fresh install follows the system', () async {
      expect(await firstTheme({}), ThemeMode.system);
    });

    test('an unknown stored value follows the system', () async {
      expect(await firstTheme({key: 'sepia'}), ThemeMode.system);
    });

    test('a stored light, dark or system choice is kept', () async {
      expect(await firstTheme({key: 'light'}), ThemeMode.light);
      expect(await firstTheme({key: 'dark'}), ThemeMode.dark);
      expect(await firstTheme({key: 'system'}), ThemeMode.system);
    });
  });
}
