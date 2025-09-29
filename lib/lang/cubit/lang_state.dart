import 'dart:ui';

import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:equatable/equatable.dart';

class LangState extends Equatable {
  const LangState({required this.locale, required this.languageType});

  final Locale locale;
  final LanguageType languageType;

  @override
  List<Object?> get props => [locale, languageType];

  LangState copyWith({Locale? locale, LanguageType? languageType}) {
    return LangState(
      languageType: languageType ?? this.languageType,
      locale: locale ?? this.locale,
    );
  }
}
