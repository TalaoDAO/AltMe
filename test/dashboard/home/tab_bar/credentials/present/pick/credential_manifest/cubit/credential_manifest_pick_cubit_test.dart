import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';

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
    late List<CredentialModel> testCredentialList;
    late InputDescriptor testInputDescriptor;
    late PresentationDefinition testPresentationDefinition;
    late List<VCFormatType> formatsSupported;

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
      testCredentialList = [testCredential, testCredential2];

      // Set formats supported
      formatsSupported = [VCFormatType.ldpVc];
    });

    test('initial state is correct', () {
      final cubit = CredentialManifestPickCubit(
        credential: testCredential,
        credentialList: testCredentialList,
        inputDescriptorIndex: 0,
        formatsSupported: formatsSupported,
        profileType: ProfileType.ebsiV3,
      );

      expect(cubit.state.selected, isEmpty);
      expect(cubit.state.presentationDefinition, isNotNull);
    });

    blocTest<CredentialManifestPickCubit, CredentialManifestPickState>(
      'toggle adds index to selected when not already selected',
      build: () => CredentialManifestPickCubit(
        credential: testCredential,
        credentialList: testCredentialList,
        inputDescriptorIndex: 0,
        formatsSupported: formatsSupported,
        profileType: ProfileType.ebsiV3,
      ),
      act: (cubit) => cubit.toggle(
        index: 0,
        inputDescriptor: testInputDescriptor,
        isVcSdJWT: false,
      ),
      expect: () => [
        isA<CredentialManifestPickState>()
            .having((state) => state.selected, 'selected', equals([0]))
            .having(
              (state) => state.isButtonEnabled,
              'isButtonEnabled',
              isTrue,
            ),
      ],
    );

    blocTest<CredentialManifestPickCubit, CredentialManifestPickState>(
      'toggle with isVcSdJWT=true sets single selection',
      build: () => CredentialManifestPickCubit(
        credential: testCredential,
        credentialList: testCredentialList,
        inputDescriptorIndex: 0,
        formatsSupported: [VCFormatType.vcSdJWT],
        profileType: ProfileType.ebsiV3,
      ),
      act: (cubit) => cubit.toggle(
        index: 1,
        inputDescriptor: testInputDescriptor,
        isVcSdJWT: true,
      ),
      expect: () => [
        isA<CredentialManifestPickState>()
            .having((state) => state.selected, 'selected', equals([1]))
            .having(
              (state) => state.isButtonEnabled,
              'isButtonEnabled',
              isTrue,
            ),
      ],
    );
  });
}
