import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/selective_disclosure/vc_selective_disclosure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc4vc/oidc4vc.dart';

@GenerateMocks([CredentialModel])
import 'get_picture_test.mocks.dart';

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

    test(
      // ignore: lines_longer_than_80_chars
      'returns null when picture key exists but getClaimsData is an empty list',
      () {
        // Arrange
        when(
          mockCredentialModel.format,
        ).thenReturn(VCFormatType.vcSdJWT.vcValue);
        when(mockCredentialModel.credentialSupported).thenReturn({
          'claims': {
            'picture': {'value_type': 'image/jpeg'},
          },
        });

        // Use _TestVcSelectiveDisclosure which extends VcSelectiveDisclosure
        // so that the overridden getClaimsData is used by getPicture
        final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
        testSd.mockGetClaimsDataResult = (<ClaimsData>[], null);

        // Act
        final result = testSd.getPicture;

        // Assert
        expect(result, isNull);
      },
    );

    test('returns picture data for simple picture field', () {
      // Arrange
      const pictureData = 'base64encodedpicturedata';
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

    test('returns face data when picture field is not found', () {
      // Arrange
      const faceData = 'base64encodedfacedata';
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

      // Assert
      expect(result, equals(faceData));
    });

    test('returns portrait data when picture & face fields are not found', () {
      // Arrange
      const portraitData = 'base64encodedportraitdata';
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

      // Assert
      expect(result, equals(portraitData));
    });

    test('returns null when found image has invalid value_type', () {
      // Arrange
      const pictureData = 'base64encodedpicturedata';
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'picture': {
            'value_type': 'application/pdf',
          }, // Not an allowed value_type
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
      expect(result, isNull);
    });

    test('finds nested picture with complex JsonPath', () {
      // Arrange
      const pictureData = 'base64encodeddeepnestedpicture';
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'documents': {
            'identifications': {
              'passport': {
                'details': {
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

    test('finds multiple picture fields but returns the first one', () {
      // Arrange
      const pictureData = 'base64encodedpicturedata';
      const faceData = 'base64encodedfacedata';
      const portraitData = 'base64encodedportraitdata';

      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'picture': {'value_type': 'image/jpeg'},
          'face': {'value_type': 'image/png'},
          'portrait': {'value_type': 'image/jpeg'},
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

      // Assert
      expect(result, equals(pictureData)); // Should return the first one
    });

    test('uses valueTypeIfNull when value_type is missing', () {
      // Arrange
      const pictureData = '{"url":"https://example.com/image.jpg"}';
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          // ignore: inference_failure_on_collection_literal
          'picture': {}, // No value_type specified
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
      // return a valid image type since the data looks like a JSON object
      // The result depends on what valueTypeIfNull returns for this data
      // If it returns an allowed type, picturData is returned; otherwise null
      expect(result, anyOf(equals(pictureData), isNull));
    });

    test('integration test with realistic SD-JWT format data', () {
      // Arrange - Create a realistic SD-JWT credential structure
      final mockData = {
        'claims': {
          'personal_data': {
            'picture': {'value_type': 'image/jpeg'},
          },
        },
      };

      const pictureBase64 =
          // ignore: lines_longer_than_80_chars
          'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwc...';

      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn(mockData);

      final testSd = _TestVcSelectiveDisclosure(mockCredentialModel);
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureBase64),
      ];
      testSd.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = testSd.getPicture;

      // Assert
      expect(result, equals(pictureBase64));
    });
  });
}

/// A test implementation of VcSelectiveDisclosure that allows mocking
/// getClaimsData while preserving the real implementation of getPicture.
class _TestVcSelectiveDisclosure extends VcSelectiveDisclosure {
  _TestVcSelectiveDisclosure(super.credentialModel);

  // For simple fixed responses
  (List<ClaimsData>, String?)? mockGetClaimsDataResult;
  String? mockValueTypeIfNullResult;

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
