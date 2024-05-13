import 'package:altme/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('KycVcType Extension Tests', () {
    test('KycVcType value returns correct value', () {
      expect(KycVcType.verifiableId.value, equals('VerifiableId'));
      expect(KycVcType.over13.value, equals('Over13'));
      expect(KycVcType.over15.value, equals('Over15'));
      expect(KycVcType.over18.value, equals('Over18'));
      expect(KycVcType.over21.value, equals('Over21'));
      expect(KycVcType.over50.value, equals('Over50'));
      expect(KycVcType.over65.value, equals('Over65'));
      expect(KycVcType.ageRange.value, equals('AgeRange'));
      expect(KycVcType.defiCompliance.value, equals('DefiCompliance'));
    });
  });
}
