import 'dart:async';

import 'package:altme/l10n/l10n.dart';
import 'package:bloc/bloc.dart';
// import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';

class LangCubit extends Cubit<Locale> {
  LangCubit() : super(const Locale('en', 'US'));

  Future<void> fetchLocale() async {
    const Locale locale = Locale('en', 'US');

    final langauageCode = locale.languageCode;

    if (AppLocalizations.supportedLocales.contains(Locale(langauageCode))) {
      setLocale(locale);
    } else {
      setLocale(const Locale('en', 'US'));
    }
  }

  void setLocale(Locale locale) {
    emit(locale);
  }
}
