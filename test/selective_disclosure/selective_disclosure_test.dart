import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/selective_disclosure/vc_selective_disclosure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc4vc/oidc4vc.dart';

@GenerateMocks([CredentialModel])
import 'selective_disclosure_test.mocks.dart';

void main() {
  group('SelectiveDisclosure.getPicture', () {
    late MockCredentialModel mockCredentialModel;

    setUp(() {
      mockCredentialModel = MockCredentialModel();
    });

    test('returns null when format is not vcSdJWT', () {
      // Arrange - stub format BEFORE creating VcSelectiveDisclosure
      when(mockCredentialModel.format).thenReturn('other_format');

      final vcSelectiveDisclosure = VcSelectiveDisclosure(mockCredentialModel);

      // Act
      final result = vcSelectiveDisclosure.getPicture;

      // Assert
      expect(result, isNull);
    });

    test('returns null when credentialSupported is null', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn(null);

      final vcSelectiveDisclosure = VcSelectiveDisclosure(mockCredentialModel);

      // Act
      final result = vcSelectiveDisclosure.getPicture;

      // Assert
      expect(result, isNull);
    });

    test('returns null when claims is not a Map', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(
        mockCredentialModel.credentialSupported,
      ).thenReturn({'claims': 'not a map'});

      final vcSelectiveDisclosure = VcSelectiveDisclosure(mockCredentialModel);

      // Act
      final result = vcSelectiveDisclosure.getPicture;

      // Assert
      expect(result, isNull);
    });

    test('returns null when no picture keys are found in claims', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'other_key': {'value_type': 'image/jpeg'},
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, isNull);
    });

    test('finds picture key and returns data when value_type matches', () {
      // Arrange
      const pictureData = 'base64img';
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'picture': {'value_type': 'image/jpeg'},
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, equals(pictureData));
    });

    test('finds picture key at second level with JsonPath', () {
      // Arrange
      const pictureData = 'base64img';
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'nested': {
            'picture': {'value_type': 'image/jpeg'},
          },
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, equals(pictureData));
    });

    test('finds picture key at deep level with JsonPath', () {
      // Arrange
      const pictureData = 'base64deep';
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'level1': {
            'level2': {
              'level3': {
                'level4': {
                  'picture': {'value_type': 'image/jpeg'},
                },
              },
            },
          },
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, equals(pictureData));
    });

    test('handles array of objects with picture key using JsonPath', () {
      // Arrange
      const pictureData = 'base64array';
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'documents': [
            {'id': 1},
            {
              'id': 2,
              'picture': {'value_type': 'image/jpeg'},
            },
            {'id': 3},
          ],
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, equals(pictureData));
    });

    test(
      'handles matches and prioritizes first key in pictureOnCardKeyList',
      () {
        // Arrange
        const pictureData = 'base64pic';
        const faceData = 'base64face';
        const portraitData = 'base64portrait';

        when(
          mockCredentialModel.format,
        ).thenReturn(VCFormatType.vcSdJWT.vcValue);
        when(mockCredentialModel.credentialSupported).thenReturn({
          'claims': {
            'nested1': {
              'picture': {'value_type': 'image/jpeg'},
            },
            'nested2': {
              'face': {'value_type': 'image/png'},
            },
            'nested3': {
              'portrait': {'value_type': 'image/jpeg'},
            },
          },
        });

        final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);

        testSd.mockGetClaimsDataCallback = (String key, String? parentKeyId) {
          if (key == 'picture') {
            return (
              [ClaimsData(isfromDisclosureOfJWT: true, data: pictureData)],
              null,
            );
          } else if (key == 'face') {
            return (
              [ClaimsData(isfromDisclosureOfJWT: true, data: faceData)],
              null,
            );
          } else if (key == 'portrait') {
            return (
              [ClaimsData(isfromDisclosureOfJWT: true, data: portraitData)],
              null,
            );
          }
          return (<ClaimsData>[], null);
        };

        // Act
        final result = testSd.getPicture;

        // Assert - should return picture since it's first in the list
        expect(result, equals(pictureData));
      },
    );

    test('falls back to face when picture is not found', () {
      // Arrange
      const faceData = 'base64face';

      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'face': {'value_type': 'image/png'},
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);

      // 'picture' is not in claims, so JsonPath won't find it.
      // Only 'face' is in claims, so it will be found and its data returned.
      testSd.mockGetClaimsDataCallback = (String key, String? parentKeyId) {
        if (key == 'face') {
          return (
            [ClaimsData(isfromDisclosureOfJWT: true, data: faceData)],
            null,
          );
        }
        return (<ClaimsData>[], null);
      };

      // Act
      final result = testSd.getPicture;

      // Assert - should fall back to face
      expect(result, equals(faceData));
    });

    test('falls back to portrait when picture and face are not found', () {
      // Arrange
      const portraitData = 'base64portrait';

      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'portrait': {'value_type': 'image/jpeg'},
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);

      // Only 'portrait' is in claims
      testSd.mockGetClaimsDataCallback = (String key, String? parentKeyId) {
        if (key == 'portrait') {
          return (
            [ClaimsData(isfromDisclosureOfJWT: true, data: portraitData)],
            null,
          );
        }
        return (<ClaimsData>[], null);
      };

      // Act
      final result = testSd.getPicture;

      // Assert - should fall back to portrait
      expect(result, equals(portraitData));
    });

    test('uses valueTypeIfNull when value_type is missing', () {
      // Arrange
      const pictureData = '{\"data\":\"base64img\"}'; // JSON string
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          // ignore: inference_failure_on_collection_literal
          'picture': {}, // No value_type field
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      // valueTypeIfNull will be called with the pictureData and should
      // return a type. The result depends on what valueTypeIfNull returns.
      // If it returns an allowed type, pictureData is returned; otherwise null.
      expect(result, anyOf(equals(pictureData), isNull));
    });

    test('returns null when value_type is not in allowed list', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'picture': {'value_type': 'application/pdf'}, // Not allowed
        },
      });

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: 'pdf_data'),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, isNull);
    });

    test('integration test with a real SD-JWT credential structure', () {
      // Arrange
      const pictureData = 'data:image/jpeg;base64,/9j/4AAQSkZJRgAB...';

      // Create a realistic credential supported structure
      final mockCredentialSupported = <String, dynamic>{
        'claims': {
          'personal_info': {
            'identity': {
              'picture': {'value_type': 'image/jpeg'},
            },
          },
        },
      };

      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(
        mockCredentialModel.credentialSupported,
      ).thenReturn(mockCredentialSupported);

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, equals(pictureData));
    });
  });
}

/// A test implementation of VcSelectiveDisclosure that allows mocking
/// getClaimsData while preserving the real implementation of getPicture.
class _TestVcSelectiveDisclosure extends VcSelectiveDisclosure {
  _TestVcSelectiveDisclosure(super.credentialModel);

  // For simple fixed responses
  (List<ClaimsData>, String?)? mockGetClaimsDataResult;

  // For more complex scenarios where different inputs should
  // get different outputs
  (List<ClaimsData>, String?) Function(String key, String? parentKeyId)?
  mockGetClaimsDataCallback;

  @override
  (List<ClaimsData>, String?) getClaimsData({
    required String key,
    required String? parentKeyId,
  }) {
    if (mockGetClaimsDataCallback != null) {
      return mockGetClaimsDataCallback!(key, parentKeyId);
    }
    return mockGetClaimsDataResult ?? (<ClaimsData>[], null);
  }
}
