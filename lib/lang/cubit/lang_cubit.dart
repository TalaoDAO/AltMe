import 'dart:async';

import 'package:altme/l10n/l10n.dart';
import 'package:bloc/bloc.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';

class LangCubit extends Cubit<Locale> {
  LangCubit() : super(const Locale('en', 'US'));

  Future<void> fetchLocale() async {
    final Locale? locale = await Devicelocale.currentAsLocale;
    const Locale frenchLocale = Locale('fr', 'FR');

    final langauageCode = locale!.languageCode;

    if (AppLocalizations.supportedLocales.contains(Locale(langauageCode))) {
      if (langauageCode == frenchLocale.languageCode) {
        emit(locale);
      }
    }
  }
}
