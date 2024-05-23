import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  final localeName = 'en_US';
}

void main() {
  group('UiDate', () {
    group('displayRegionalDate', () {
      test('should return formatted date for valid input', () {
        const dateString = '2024-05-20';
        final localizations = MockAppLocalizations();

        final result = UiDate.displayRegionalDate(localizations, dateString);
        expect(result, '5/20/2024');
      });

      test('should return empty string for empty input', () {
        final localizations = MockAppLocalizations();

        final result = UiDate.displayRegionalDate(localizations, '');

        expect(result, '');
      });

      test('should return empty string for invalid input', () {
        final localizations = MockAppLocalizations();

        final result = UiDate.displayRegionalDate(localizations, 'invalid');

        expect(result, '');
      });
    });

    test('formatStringDate returns formatted date', () {
      const dateTime = '2022-05-10T10:00:00Z';
      expect(UiDate.formatStringDate(dateTime), '2022-05-10');
    });

    test('formatDate returns formatted date', () {
      final dateTime = DateTime(2022, 5, 10);
      expect(UiDate.formatDate(dateTime), '2022-05-10');
    });

    test(
        // ignore: lines_longer_than_80_chars
        'formatDateForCredentialCard returns formatted date for credential card',
        () {
      const timestamp = '1643738400';
      expect(UiDate.formatDateForCredentialCard(timestamp), '2022-02-01');
    });

    group('isTimestampString', () {
      test('returns true for valid timestamp string', () {
        const timestamp = '1643738400';
        expect(UiDate.isTimestampString(timestamp), true);
      });

      test('returns false for invalid timestamp string', () {
        const invalidTimestamp = 'abc';
        expect(UiDate.isTimestampString(invalidTimestamp), false);
      });
    });

    group('normalFormat', () {
      test('returns formatted date and time', () {
        const dateTime = '2022-05-10T10:00:00Z';
        expect(UiDate.normalFormat(dateTime), '10-05-2022 15:45');
      });
      test('returns null if format is empty', () {
        const dateTime = '';
        expect(UiDate.normalFormat(dateTime), null);
      });

      test('returns null if format is incorrect', () {
        const dateTime = 'asdf';
        expect(UiDate.normalFormat(dateTime), null);
      });
    });
  });
}
