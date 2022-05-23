import 'package:altme/home/credentials/credential.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Author model work properly', () {
    test('initialize Author with default constructor', () {
      const author = Author('Taleb', 'logo');
      expect(author.name, 'Taleb');
      expect(author.logo, 'logo');
    });

    test('initialize Author fromJson constructor', () {
      const authorJson = <String, dynamic>{
        'name': 'Taleb',
        'logo': 'logo',
      };
      final author = Author.fromJson(authorJson);
      expect(author.name, 'Taleb');
      expect(author.logo, 'logo');
    });

    test('Author toJson worked correct', () {
      const authorJson = <String, dynamic>{
        'name': 'Taleb',
        'logo': 'logo',
      };
      final author = Author.fromJson(authorJson);
      expect(author.toJson(), authorJson);
    });
  });
}
