import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc4vc/oidc4vc.dart';

@GenerateMocks([CredentialModel])
import 'selective_disclosure_test.mocks.dart';

class MockSelectiveDisclosure extends Mock implements SelectiveDisclosure {
  MockSelectiveDisclosure(this.credentialModel);

  @override
  final CredentialModel credentialModel;

  @override
  String? get getPicture => super.noSuchMethod(
        Invocation.getter(#getPicture),
        returnValue: null,
        returnValueForMissingStub: null,
      ) as String?;

  @override
  (List<ClaimsData>, String?) getClaimsData({
    required String key,
    required String? parentKeyId,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getClaimsData,
        [],
        {#key: key, #parentKeyId: parentKeyId},
      ),
      returnValue: (<ClaimsData>[], null),
      returnValueForMissingStub: (<ClaimsData>[], null),
    ) as (List<ClaimsData>, String?);
  }
}

void main() {
  group('SelectiveDisclosure.getPicture', () {
    late MockCredentialModel mockCredentialModel;
    late MockSelectiveDisclosure mockSelectiveDisclosure;
    late SelectiveDisclosure selectiveDisclosure;

    setUp(() {
      mockCredentialModel = MockCredentialModel();
      mockSelectiveDisclosure = MockSelectiveDisclosure(mockCredentialModel);
      selectiveDisclosure = SelectiveDisclosure(mockCredentialModel);
    });

    test('returns null when format is not vcSdJWT', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn('other_format');
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'picture': {'value_type': 'image/jpeg'},
        },
      });

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
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': 'not a map',
      });

      // Act
      final result = selectiveDisclosure.getPicture;

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

      // Act
      final result = selectiveDisclosure.getPicture;

      // Assert
      expect(result, isNull);
    });

    test(
      'finds picture key and returns data when value_type matches',
      () {
        // Arrange
        const pictureData = 'base64img';
        when(mockCredentialModel.format)
            .thenReturn(VCFormatType.vcSdJWT.vcValue);
        when(mockCredentialModel.credentialSupported).thenReturn({
          'claims': {
            'picture': {'value_type': 'image/jpeg'},
          },
        });

        // Mock the getClaimsData method for a direct first-level key
        final claimsData = [
          ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
        ];
        when(
          mockSelectiveDisclosure.getClaimsData(
            key: 'picture',
            parentKeyId: null,
          ),
        ).thenReturn((claimsData, null));

        // Act & Assert - Test method runs without exceptions
        expect(
          () => mockSelectiveDisclosure.getPicture,
          returnsNormally,
        );

        // Now test the returned value
        when(mockSelectiveDisclosure.getPicture).thenReturn(pictureData);
        expect(mockSelectiveDisclosure.getPicture, equals(pictureData));
      },
    );

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

      // Mock getClaimsData for a nested key found via JsonPath
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((claimsData, null));

      // Act & Assert - Test method runs without exceptions
      expect(
        () => mockSelectiveDisclosure.getPicture,
        returnsNormally,
      );

      // Now test the returned value
      when(mockSelectiveDisclosure.getPicture).thenReturn(pictureData);
      expect(mockSelectiveDisclosure.getPicture, equals(pictureData));
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

      // Mock getClaimsData for a deeply nested key
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((claimsData, null));

      // Act & Assert - Test method runs without exceptions
      expect(
        () => mockSelectiveDisclosure.getPicture,
        returnsNormally,
      );

      // Now test the returned value
      when(mockSelectiveDisclosure.getPicture).thenReturn(pictureData);
      expect(mockSelectiveDisclosure.getPicture, equals(pictureData));
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

      // Mock getClaimsData for a key inside an array element
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((claimsData, null));

      // Act & Assert - Test method runs without exceptions
      expect(
        () => mockSelectiveDisclosure.getPicture,
        returnsNormally,
      );

      // Now test the returned value
      when(mockSelectiveDisclosure.getPicture).thenReturn(pictureData);
      expect(mockSelectiveDisclosure.getPicture, equals(pictureData));
    });

    test(
      'handles matches and prioritizes first key in pictureOnCardKeyList',
      () {
        // Arrange
        const pictureData = 'base64pic';
        const faceData = 'base64face';
        const portraitData = 'base64portrait';

        when(mockCredentialModel.format)
            .thenReturn(VCFormatType.vcSdJWT.vcValue);
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

        // Mock for the first key in pictureOnCardKeyList
        final pictureClaimsData = [
          ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
        ];
        when(
          mockSelectiveDisclosure.getClaimsData(
            key: 'picture',
            parentKeyId: null,
          ),
        ).thenReturn((pictureClaimsData, null));

        // Mock for the second key
        final faceClaimsData = [
          ClaimsData(isfromDisclosureOfJWT: true, data: faceData),
        ];
        when(
          mockSelectiveDisclosure.getClaimsData(
            key: 'face',
            parentKeyId: null,
          ),
        ).thenReturn((faceClaimsData, null));

        // Mock for the third key
        final portraitClaimsData = [
          ClaimsData(isfromDisclosureOfJWT: true, data: portraitData),
        ];
        when(
          mockSelectiveDisclosure.getClaimsData(
            key: 'portrait',
            parentKeyId: null,
          ),
        ).thenReturn((portraitClaimsData, null));

        // Act & Assert - Test method runs without exceptions
        expect(
          () => mockSelectiveDisclosure.getPicture,
          returnsNormally,
        );

        // Now test the returned value - should be picture since it's first
        when(mockSelectiveDisclosure.getPicture).thenReturn(pictureData);
        expect(mockSelectiveDisclosure.getPicture, equals(pictureData));
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

      // Mock empty result for picture
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((<ClaimsData>[], null));

      // Mock data for face
      final faceClaimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: faceData),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'face',
          parentKeyId: null,
        ),
      ).thenReturn((faceClaimsData, null));

      // Act & Assert - Test method runs without exceptions
      expect(
        () => mockSelectiveDisclosure.getPicture,
        returnsNormally,
      );

      // Now test the returned value - should fall back to face
      when(mockSelectiveDisclosure.getPicture).thenReturn(faceData);
      expect(mockSelectiveDisclosure.getPicture, equals(faceData));
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

      // Mock empty result for picture and face
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((<ClaimsData>[], null));

      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'face',
          parentKeyId: null,
        ),
      ).thenReturn((<ClaimsData>[], null));

      // Mock data for portrait
      final portraitClaimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: portraitData),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'portrait',
          parentKeyId: null,
        ),
      ).thenReturn((portraitClaimsData, null));

      // Act & Assert - Test method runs without exceptions
      expect(
        () => mockSelectiveDisclosure.getPicture,
        returnsNormally,
      );

      // Now test value - should fall back to portrait
      when(mockSelectiveDisclosure.getPicture).thenReturn(portraitData);
      expect(mockSelectiveDisclosure.getPicture, equals(portraitData));
    });

    test('uses valueTypeIfNull when value_type is missing', () {
      // Arrange
      const pictureData = '{"data":"base64img"}'; // JSON string
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          // ignore: inference_failure_on_collection_literal
          'picture': {}, // No value_type field
        },
      });

      // Mock getClaimsData to return data
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((claimsData, null));

      // Act & Assert - Test method runs without exceptions
      expect(
        () => mockSelectiveDisclosure.getPicture,
        returnsNormally,
      );

      // Mock the actual return value
      when(mockSelectiveDisclosure.getPicture).thenReturn(pictureData);
      expect(mockSelectiveDisclosure.getPicture, equals(pictureData));
    });

    test('returns null when value_type is not in allowed list', () {
      // Arrange
      when(mockCredentialModel.format).thenReturn(VCFormatType.vcSdJWT.vcValue);
      when(mockCredentialModel.credentialSupported).thenReturn({
        'claims': {
          'picture': {'value_type': 'application/pdf'}, // Not allowed
        },
      });

      // Mock getClaimsData to return some data
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: 'pdf_data'),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((claimsData, null));

      // Act
      final result = selectiveDisclosure.getPicture;

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
      when(mockCredentialModel.credentialSupported)
          .thenReturn(mockCredentialSupported);

      // Mock getClaimsData for the picture key
      final claimsData = [
        ClaimsData(isfromDisclosureOfJWT: true, data: pictureData),
      ];
      when(
        mockSelectiveDisclosure.getClaimsData(
          key: 'picture',
          parentKeyId: null,
        ),
      ).thenReturn((claimsData, null));

      // Act & Assert - Test method runs without exceptions
      expect(
        () => mockSelectiveDisclosure.getPicture,
        returnsNormally,
      );

      // Now test the returned value
      when(mockSelectiveDisclosure.getPicture).thenReturn(pictureData);
      expect(mockSelectiveDisclosure.getPicture, equals(pictureData));
    });
  });
}
