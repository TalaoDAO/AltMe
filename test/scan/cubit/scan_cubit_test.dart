// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential/credential.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

// Generate mock classes
@GenerateMocks([
  DioClient,
  CredentialsCubit,
  DIDKitProvider,
  SecureStorageProvider,
  ProfileCubit,
  WalletCubit,
  OIDC4VC,
  JWTDecode,
  ActivityLogManager,
])
import 'scan_cubit_test.mocks.dart'; // This will be generated by build_runner

// Manual mock for credential
class MockCredentialSubjectModel extends Mock
    implements CredentialSubjectModel {
  @override
  CredentialSubjectType get credentialSubjectType =>
      CredentialSubjectType.defaultCredential;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'CredentialSubjectModel',
        'credentialSubjectType': 'defaultCredential',
      };
}

class MockCredentialPreview extends Mock implements Credential {
  @override
  List<String> get type => ['VerifiableCredential'];

  @override
  CredentialSubjectModel get credentialSubjectModel =>
      MockCredentialSubjectModel();

  @override
  Map<String, dynamic> toJson() => {
        'type': ['VerifiableCredential'],
        'credentialSubjectModel': credentialSubjectModel.toJson(),
      };
}

void main() {
  group('ScanCubit', () {
    late MockDioClient mockDioClient;
    late MockCredentialsCubit mockCredentialsCubit;
    late MockDIDKitProvider mockDIDKitProvider;
    late MockSecureStorageProvider mockSecureStorageProvider;
    late MockProfileCubit mockProfileCubit;
    late MockWalletCubit mockWalletCubit;
    late MockOIDC4VC mockOIDC4VC;
    late MockJWTDecode mockJWTDecode;
    late ScanCubit scanCubit;
    late MockActivityLogManager mockActivityLogManager;

    setUp(() {
      mockDioClient = MockDioClient();
      mockCredentialsCubit = MockCredentialsCubit();
      mockDIDKitProvider = MockDIDKitProvider();
      mockSecureStorageProvider = MockSecureStorageProvider();
      mockProfileCubit = MockProfileCubit();
      mockWalletCubit = MockWalletCubit();
      mockOIDC4VC = MockOIDC4VC();
      mockJWTDecode = MockJWTDecode();
      mockActivityLogManager = MockActivityLogManager();

      scanCubit = ScanCubit(
        client: mockDioClient,
        credentialsCubit: mockCredentialsCubit,
        didKitProvider: mockDIDKitProvider,
        secureStorageProvider: mockSecureStorageProvider,
        profileCubit: mockProfileCubit,
        walletCubit: mockWalletCubit,
        oidc4vc: mockOIDC4VC,
        jwtDecode: mockJWTDecode,
        activityLogManager: mockActivityLogManager,
      );
    });

    test('initial state is ScanState', () {
      expect(scanCubit.state, equals(const ScanState()));
    });

    group('createVpToken', () {
      const privateKey =
          '{"kty":"EC","crv":"P-256","d":"test-private-key","x":"test-x","y":"test-y"}';
      const did = 'did:key:test';
      const kid = 'did:key:test#key-1';
      final uri = Uri.parse(
          'https://example.com/auth?client_id=test_client&nonce=test_nonce',);

      final profileSetting = ProfileSetting.initial();
      final customOidc4vcProfile =
          profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;

      final credentialData = {
        'id': 'urn:uuid:${const Uuid().v4()}',
        'type': ['VerifiableCredential'],
        'issuer': {'id': 'did:key:test_issuer'},
        'credentialSubject': {'id': did, 'name': 'Test Subject'},
      };

      late CredentialModel mockCredential;
      late CredentialModel secondCredential;
      late ProfileState profileState;

      setUp(() {
        // Setup ProfileCubit state
        final profileModel = ProfileModel.empty();
        profileState = ProfileState(model: profileModel);
        when(mockProfileCubit.state).thenReturn(profileState);

        // Create mock credential preview
        final credentialPreview = MockCredentialPreview();

        // Create test credentials
        mockCredential = CredentialModel(
          id: 'test_credential_id',
          data: credentialData,
          credentialPreview: credentialPreview,
          shareLink: '',
          image: '',
          selectiveDisclosureJwt: 'test_sd_jwt',
        );

        secondCredential = CredentialModel(
          id: 'second_credential_id',
          data: credentialData,
          credentialPreview: credentialPreview,
          shareLink: '',
          image: '',
          selectiveDisclosureJwt: 'second_sd_jwt',
        );
      });

      test(
          'returns credential when formatFromPresentationSubmission is vcSdJWT with single credential',
          () async {
        // Arrange
        final presentationDefinition = PresentationDefinition(
          id: 'test_presentation',
          inputDescriptors: <InputDescriptor>[],
        );

        // Act
        final result = await scanCubit.createVpToken(
          credentialsToBePresented: [mockCredential],
          presentationDefinition: presentationDefinition,
          oidc4vc: mockOIDC4VC,
          privateKey: privateKey,
          did: did,
          kid: kid,
          uri: uri,
          clientMetaData: null,
          profileSetting: profileSetting,
          formatFromPresentationSubmission: VCFormatType.vcSdJWT,
        );

        // Assert
        expect(result, isNotNull);
      });

      test(
          'returns encoded credentials list when formatFromPresentationSubmission is vcSdJWT with multiple credentials',
          () async {
        // Arrange
        final presentationDefinition = PresentationDefinition(
          id: 'test_presentation',
          inputDescriptors: <InputDescriptor>[],
        );

        // Act
        final result = await scanCubit.createVpToken(
          credentialsToBePresented: [mockCredential, secondCredential],
          presentationDefinition: presentationDefinition,
          oidc4vc: mockOIDC4VC,
          privateKey: privateKey,
          did: did,
          kid: kid,
          uri: uri,
          clientMetaData: null,
          profileSetting: profileSetting,
          formatFromPresentationSubmission: VCFormatType.vcSdJWT,
        );

        // Assert
        expect(result, isNotNull);
        try {
          final decodedResult = jsonDecode(result) as List<dynamic>;
          expect(decodedResult, isA<List<dynamic>>());
        } catch (e) {
          // If decoding fails, the result isn't a JSON list
          fail('Result is not a valid JSON list: $result');
        }
      });

      test(
          'calls oidc4vc.extractVpToken when formatFromPresentationSubmission is jwtVc',
          () async {
        // Arrange
        final presentationDefinition = PresentationDefinition(
          id: 'test_presentation',
          inputDescriptors: <InputDescriptor>[],
        );

        const vpToken = 'mocked_vp_token';

        when(mockOIDC4VC.extractVpToken(
          clientId: anyNamed('clientId'),
          credentialsToBePresented: anyNamed('credentialsToBePresented'),
          did: anyNamed('did'),
          kid: anyNamed('kid'),
          privateKey: anyNamed('privateKey'),
          nonce: anyNamed('nonce'),
          proofHeaderType: anyNamed('proofHeaderType'),
        ),).thenAnswer((_) async => vpToken);

        // Act
        final result = await scanCubit.createVpToken(
          credentialsToBePresented: [mockCredential],
          presentationDefinition: presentationDefinition,
          oidc4vc: mockOIDC4VC,
          privateKey: privateKey,
          did: did,
          kid: kid,
          uri: uri,
          clientMetaData: null,
          profileSetting: profileSetting,
          formatFromPresentationSubmission: VCFormatType.jwtVc,
        );

        // Assert
        verify(mockOIDC4VC.extractVpToken(
          clientId: 'test_client',
          credentialsToBePresented: anyNamed('credentialsToBePresented'),
          did: did,
          kid: kid,
          privateKey: privateKey,
          nonce: 'test_nonce',
          proofHeaderType: customOidc4vcProfile.proofHeader,
        ),).called(1);

        expect(result, equals(vpToken));
      });

      test(
          'calls didKitProvider.issuePresentation when formatFromPresentationSubmission is ldpVc',
          () async {
        // Arrange
        final presentationDefinition = PresentationDefinition(
          id: 'test_presentation',
          inputDescriptors: <InputDescriptor>[],
        );

        const vpToken = 'mocked_didkit_vp_token';

        when(mockDIDKitProvider.issuePresentation(
          argThat(isA<String>()),
          argThat(isA<String>()),
          argThat(isA<String>()),
        ),).thenAnswer((_) async => vpToken);

        // Act
        final result = await scanCubit.createVpToken(
          credentialsToBePresented: [mockCredential],
          presentationDefinition: presentationDefinition,
          oidc4vc: mockOIDC4VC,
          privateKey: privateKey,
          did: did,
          kid: kid,
          uri: uri,
          clientMetaData: null,
          profileSetting: profileSetting,
          formatFromPresentationSubmission: VCFormatType.ldpVc,
        );

        // Assert
        verify(mockDIDKitProvider.issuePresentation(
          argThat(isA<String>()),
          argThat(isA<String>()),
          argThat(isA<String>()),
        ),).called(1);

        expect(result, equals(vpToken));
      });

      test(
          'throws Exception when formatFromPresentationSubmission is not supported',
          () async {
        // Arrange
        final presentationDefinition = PresentationDefinition(
          id: 'test_presentation',
          inputDescriptors: <InputDescriptor>[],
        );

        // Act & Assert
        expect(
          () => scanCubit.createVpToken(
            credentialsToBePresented: [mockCredential],
            presentationDefinition: presentationDefinition,
            oidc4vc: mockOIDC4VC,
            privateKey: privateKey,
            did: did,
            kid: kid,
            uri: uri,
            clientMetaData: null,
            profileSetting: profileSetting,
            formatFromPresentationSubmission: null,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
