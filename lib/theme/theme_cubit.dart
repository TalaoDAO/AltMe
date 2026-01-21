import 'dart:async';

import 'package:altme/theme/theme_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

// https://dev.to/b_plab98/theme-switching-persisting-in-flutter-using-cubits-and-stream-5553
// https://medium.com/flutter-community/create-a-theme-and-primary-color-switcher-for-your-flutter-app-using-provider-fd334dd7d761

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required ThemePersistence themeRepository})
    : _themeRepository = themeRepository,
      super(const ThemeState());

  final ThemePersistence _themeRepository;
  late StreamSubscription<ThemeMode> _themeSubscription;

  void getCurrentTheme() {
    // Since `getTheme()` returns a stream, we listen to the output
    _themeSubscription = _themeRepository.getTheme().listen((themeMode) {
      emit(state.copyWith(themeMode: themeMode));
    });
  }

  void switchTheme(ThemeMode themeMode) {
    _themeRepository.saveTheme(themeMode);
  }

  @override
  Future<void> close() {
    _themeSubscription.cancel();
    _themeRepository.dispose();
    return super.close();
  }
}
