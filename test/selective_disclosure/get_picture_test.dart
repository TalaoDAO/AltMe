import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc4vc/oidc4vc.dart';

@GenerateMocks([CredentialModel])
import 'get_picture_test.mocks.dart';

void main() {
  group('SelectiveDisclosure.getPicture', () {
    late MockCredentialModel mockCredentialModel;
    late SelectiveDisclosure selectiveDisclosure;

    setUp(() {
      mockCredentialModel = MockCredentialModel();
      selectiveDisclosure = SelectiveDisclosure(mockCredentialModel);
    });

    test('returns null when format is not vcSdJWT', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn('other_format');

      // Act
      final result = selectiveDisclosure.getPicture;

      // Assert
      expect(result, isNull);
    });

    test('returns null when credentialSupported is null', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn(null);

      // Act
      final result = selectiveDisclosure.getPicture;

      // Assert
      expect(result, isNull);
    });

    test('returns null when claims is not a Map', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(
        mockCredentialModel.credentialSupported,
      ).thenReturn({'claims': 'not a map'});

      // Act
      final result = selectiveDisclosure.getPicture;

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

        // Mock the real SelectiveDisclosure to intercept getClaimsData calls
        final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
          mockCredentialModel,
        );
        // Mock empty claims data result
        realSelectiveDisclosure.mockGetClaimsDataResult = (
          <ClaimsData>[],
          null,
        );

        // Act
        final result = realSelectiveDisclosure.getPicture;

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

      // Mock the real SelectiveDisclosure with actual claims data
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      realSelectiveDisclosure.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = realSelectiveDisclosure.getPicture;

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

      // Mock the real SelectiveDisclosure with conditional claims data results
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );

      // Set up mock to return different results based on which key is requested
      realSelectiveDisclosure.mockGetClaimsDataCallback =
          (String key, String? parentKeyId) {
            if (key == 'picture') {
              return (<ClaimsData>[], null);
            } else if (key == 'face') {
              return (
                [ClaimsData(isfromDisclosureOfJWT: true, data: faceData)],
                null,
              );
            }
            return (<ClaimsData>[], null);
          };

      // Act
      final result = realSelectiveDisclosure.getPicture;

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

      // Mock the real SelectiveDisclosure with conditional claims data results
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );

      // Set up mock to return different results based on which key is requested
      realSelectiveDisclosure.mockGetClaimsDataCallback =
          (String key, String? parentKeyId) {
            if (key == 'picture' || key == 'face') {
              return (<ClaimsData>[], null);
            } else if (key == 'portrait') {
              return (
                [ClaimsData(isfromDisclosureOfJWT: true, data: portraitData)],
                null,
              );
            }
            return (<ClaimsData>[], null);
          };

      // Act
      final result = realSelectiveDisclosure.getPicture;

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

      // Mock the real SelectiveDisclosure
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      realSelectiveDisclosure.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = realSelectiveDisclosure.getPicture;

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

      // Mock the real SelectiveDisclosure
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      realSelectiveDisclosure.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = realSelectiveDisclosure.getPicture;

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

      // Mock the real SelectiveDisclosure
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );

      // Set up mock to return different results based on which key is requested
      realSelectiveDisclosure.mockGetClaimsDataCallback =
          (String key, String? parentKeyId) {
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
      final result = realSelectiveDisclosure.getPicture;

      // Assert
      expect(result, equals(pictureData)); // Should return the first one,
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

      // Mock the real SelectiveDisclosure
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      realSelectiveDisclosure.mockGetClaimsDataResult = (claimsData, null);
      realSelectiveDisclosure.mockValueTypeIfNullResult = 'image/jpeg';

      // Act
      final result = realSelectiveDisclosure.getPicture;

      // Assert
      expect(result, equals(pictureData));
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
          'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwc...';

      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn(mockData);

      // Mock the real SelectiveDisclosure
      final realSelectiveDisclosure = _MockRealSelectiveDisclosure(
        mockCredentialModel,
      );
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureBase64),
      ];
      realSelectiveDisclosure.mockGetClaimsDataResult = (claimsData, null);

      // Act
      final result = realSelectiveDisclosure.getPicture;

      // Assert
      expect(result, equals(pictureBase64));
    });
  });
}

/// A test implementation of SelectiveDisclosure that allows mocking specific
/// methods while preserving the real implementation of getPicture
class _MockRealSelectiveDisclosure extends SelectiveDisclosure {
  _MockRealSelectiveDisclosure(super.credentialModel);

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
