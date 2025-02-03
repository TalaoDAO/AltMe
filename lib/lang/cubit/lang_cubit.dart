import 'dart:async';

import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/app/shared/shared.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:bloc/bloc.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class LangCubit extends Cubit<LangState> {
  LangCubit({required this.secureStorageProvider})
      : super(
          const LangState(
            locale: Locale('en'),
            languageType: LanguageType.phone,
          ),
        );
  final SecureStorageProvider secureStorageProvider;

  /// emit new state if language recorded is dufferent than english
  Future<void> checkLocale() async {
    final languageType = await getRecordedLanguage();
    if (languageType == LanguageType.phone) {
      final newLocale =
          await Devicelocale.currentAsLocale ?? const Locale('en');

      emit(state.copyWith(languageType: languageType, locale: newLocale));
    } else {
      emit(
        state.copyWith(
          languageType: languageType,
          locale: Locale(
            languageType.name,
          ),
        ),
      );
    }
  }

  Future<LanguageType> getRecordedLanguage() async {
    LanguageType languageType = LanguageType.phone;
    final languageTypeString =
        await secureStorageProvider.get(SecureStorageKeys.language);
    if (languageTypeString != null) {
      languageType = getLanguageType(languageTypeString, languageType);
    } else {
      await recordLanguage(LanguageType.phone.name);
      languageType = LanguageType.phone;
    }
    return languageType;
  }

  LanguageType getLanguageType(
    String languageTypeString,
    LanguageType languageType,
  ) {
    final enumVal = LanguageType.values.firstWhereOrNull(
      (ele) => ele.name == languageTypeString,
    );
    if (enumVal != null) {
      return enumVal;
    }
    return languageType;
  }

  Future<void> recordLanguage(String language) async {
    await secureStorageProvider.set(
      SecureStorageKeys.language,
      language,
    );
  }

  Future<void> setLocale(Locale locale) async {
    Locale newLocale = const Locale('en');
    LanguageType newlanguageType = LanguageType.phone;
    if (locale == Locale(LanguageType.phone.name)) {
      await recordLanguage(LanguageType.phone.name);

      newLocale = await Devicelocale.currentAsLocale ?? const Locale('en');
    } else {
      await recordLanguage(locale.languageCode);
      newLocale = locale;
      newlanguageType = getLanguageType(locale.languageCode, newlanguageType);
    }
    if (AppLocalizations.supportedLocales
        .contains(Locale(newLocale.languageCode))) {
      emit(LangState(languageType: newlanguageType, locale: newLocale));
    } else {
      emit(
        LangState(
          languageType: newlanguageType,
          locale: const Locale('en'),
        ),
      );
    }
  }
}
