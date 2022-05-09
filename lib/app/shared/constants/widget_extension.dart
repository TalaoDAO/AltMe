import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension WidgetExtension on Widget {
  String getTranslation(List<Translation> translations) {
    String _translation;
    var translated = translations
        .where((element) => element.language == Intl.getCurrentLocale());
    if (translated.isEmpty) {
      var titi = translations.where((element) => element.language == 'en');
      if (titi.isEmpty) {
        _translation = '';
      } else {
        _translation = titi.single.value;
      }
    } else {
      _translation = translated.single.value;
    }
    return _translation;
  }
}
