import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Author model work properly', () {
    test('initialize Author with default constructor', () {
      const author = Author('Test');
      expect(author.name, 'Test');
    });

    test('initialize Author fromJson constructor', () {
      const authorJson = <String, dynamic>{
        'name': 'Test1',
        'logo': 'logo',
      };
      final author = Author.fromJson(authorJson);
      expect(author.name, 'Test1');
    });

    test('Author toJson worked correct', () {
      const author = Author('Test');

      final json = author.toJson();

      expect(json['name'], 'Test');
    });
  });
}
