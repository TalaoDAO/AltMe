import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemePersistence {
  Stream<ThemeMode> getTheme();
  Future<void> saveTheme(ThemeMode theme);
  void dispose();
}

class ThemeRepository implements ThemePersistence {
  ThemeRepository({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences {
    _init();
  }

  final SharedPreferences _sharedPreferences;

  static const _kThemePersistenceKey = '__theme_persistence_key__';

  final _controller = StreamController<ThemeMode>();

  String? _getValue(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (_) {
      return null;
    }
  }

  Future<void> _setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);

  void _init() {
    final themeString = _getValue(_kThemePersistenceKey);

    if (themeString != null) {
      switch (themeString) {
        case 'light':
          _controller.add(ThemeMode.light);
        case 'dark':
          _controller.add(ThemeMode.dark);
        case 'system':
          _controller.add(ThemeMode.system);
        default:
          _controller.add(ThemeMode.dark);
      }
    } else {
      _controller.add(Parameters.defaultTheme);
    }
  }

  @override
  Stream<ThemeMode> getTheme() async* {
    yield* _controller.stream;
  }

  @override
  Future<void> saveTheme(ThemeMode theme) {
    _controller.add(theme);
    return _setValue(_kThemePersistenceKey, theme.name);
  }

  @override
  void dispose() => _controller.close();
}
