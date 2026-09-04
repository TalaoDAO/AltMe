import 'package:altme/dashboard/dashboard.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCredentialModel extends Mock implements CredentialModel {}

class MockCredential extends Mock implements Credential {}

class MockCredentialManifest extends Mock implements CredentialManifest {}

class MockPresentationDefinition extends Mock
    implements PresentationDefinition {}

class MockInputDescriptor extends Mock implements InputDescriptor {}

class MockConstraints extends Mock implements Constraints {}

void main() {
  group('CredentialManifestPickCubit', () {
    late CredentialModel testCredential;
    late InputDescriptor testInputDescriptor;
    late PresentationDefinition testPresentationDefinition;

    setUp(() {
      // Create mocks
      testCredential = MockCredentialModel();
      testInputDescriptor = MockInputDescriptor();
      testPresentationDefinition = MockPresentationDefinition();
      final mockCredentialManifest = MockCredentialManifest();

      // Setup credential manifest
      when(
        () => mockCredentialManifest.presentationDefinition,
      ).thenReturn(testPresentationDefinition);
      when(
        () => testCredential.credentialManifest,
      ).thenReturn(mockCredentialManifest);
      when(() => testCredential.id).thenReturn('test-id');
      when(() => testCredential.getFormat).thenReturn('jwt_vc');

      // Setup presentation definition
      when(
        () => testPresentationDefinition.inputDescriptors,
      ).thenReturn([testInputDescriptor]);
      when(
        () => testPresentationDefinition.id,
      ).thenReturn('test-presentation-id');

      // Setup input descriptor
      when(() => testInputDescriptor.id).thenReturn('test-input-descriptor');
      when(() => testInputDescriptor.name).thenReturn('Test Input Descriptor');
      when(() => testInputDescriptor.purpose).thenReturn('For testing');

      final mockConstraints = MockConstraints();
      when(() => testInputDescriptor.constraints).thenReturn(mockConstraints);
      when(() => mockConstraints.fields).thenReturn([]);

      // Create test credential list
      final testCredential2 = MockCredentialModel();
      when(() => testCredential2.id).thenReturn('test-id-2');
      when(() => testCredential2.getFormat).thenReturn('jwt_vc');

      // Set formats supported
    });
  });
}
