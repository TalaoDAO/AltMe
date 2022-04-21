import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Translation model', () {
    test('default constructor work correctly', () {
      final translation = Translation('en', 'Translation');
      expect(translation.language, 'en');
      expect(translation.value, 'Translation');
    });

    test('fromJson constructor work correctly', () {
      final translation = Translation.fromJson(
        <String, dynamic>{'@language': 'fr', '@value': 'Translation'},
      );
      expect(translation.language, 'fr');
      expect(translation.value, 'Translation');
    });

    test('toJson constructor work correctly', () {
      final json = <String, dynamic>{
        '@language': 'fr',
        '@value': 'Translation'
      };
      final translation = Translation.fromJson(json);

      expect(translation.toJson(), json);
    });

    test('default values work correctly with empty json', () {
      final translation = Translation.fromJson(
        <String, dynamic>{},
      );
      expect(translation.language, 'en');
      expect(translation.value, '');
    });
  });
}
