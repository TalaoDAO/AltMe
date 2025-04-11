import 'package:altme/app/app.dart';
import 'package:altme/app/shared/issuer/models/organization_info.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';

// Mock classes
class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockCredentialManifestPickCubit
    extends MockCubit<CredentialManifestPickState>
    implements CredentialManifestPickCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class MockScanCubit extends MockCubit<ScanState> implements ScanCubit {}

class MockQRCodeScanCubit extends Mock implements QRCodeScanCubit {}

class MockLocalAuthApi extends Mock implements LocalAuthApi {}

class MockOIDC4VC extends Mock implements OIDC4VC {}

class MockCredentialModel extends Mock implements CredentialModel {}

class MockIssuer extends Mock implements Issuer {}

class MockOrganizationInfo extends Mock implements OrganizationInfo {}

class MockCredential extends Mock implements Credential {}

class MockCredentialSubjectModel extends Mock
    implements CredentialSubjectModel {}

class MockProfileModel extends Mock implements ProfileModel {}

class MockCredentialManifest extends Mock implements CredentialManifest {}

class MockProfileState extends Fake implements ProfileState {
  MockProfileState({required this.model});

  @override
  final ProfileModel model;

  @override
  AppStatus get status => AppStatus.idle;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
        const CredentialManifestPickState(filteredCredentialList: []),);
    registerFallbackValue(const CredentialsState(
        status: CredentialsStatus.idle, credentials: [],),);
    registerFallbackValue(const ScanState());
    registerFallbackValue(MockProfileState(model: MockProfileModel()));
    registerFallbackValue(Uri());
  });

  group('CredentialManifestOfferPickPage Basic Rendering', () {
    late MockProfileCubit profileCubit;
    late MockCredentialManifestPickCubit credentialManifestPickCubit;
    late MockCredentialsCubit credentialsCubit;
    late MockScanCubit scanCubit;
    late MockQRCodeScanCubit qrCodeScanCubit;
    late MockCredentialModel credential;
    late MockIssuer issuer;
    late MockOrganizationInfo organizationInfo;
    late MockCredentialManifest credentialManifest;
    late MockProfileModel profileModel;
    late PresentationDefinition presentationDefinition;
    late InputDescriptor inputDescriptor;

    setUp(() {
      profileCubit = MockProfileCubit();
      credentialManifestPickCubit = MockCredentialManifestPickCubit();
      credentialsCubit = MockCredentialsCubit();
      scanCubit = MockScanCubit();
      qrCodeScanCubit = MockQRCodeScanCubit();
      credential = MockCredentialModel();
      issuer = MockIssuer();
      organizationInfo = MockOrganizationInfo();
      credentialManifest = MockCredentialManifest();
      profileModel = MockProfileModel();

      // Set up profile model
      when(() => profileModel.profileSetting).thenReturn(
        ProfileSetting(
          walletSecurityOptions: WalletSecurityOptions.initial(),
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          settingsMenu: SettingsMenu.initial(),
          version: '1.0.0',
        ),
      );
      when(() => profileModel.profileType).thenReturn(ProfileType.ebsiV3);

      // Set up profile cubit
      when(() => profileCubit.state).thenReturn(
        MockProfileState(model: profileModel),
      );

      // Set up organization info and issuer
      when(() => organizationInfo.website).thenReturn('example.com');
      when(() => issuer.preferredName).thenReturn('Test Issuer');
      when(() => issuer.organizationInfo).thenReturn(organizationInfo);

      // Set up input descriptor
      inputDescriptor = InputDescriptor(
        id: '1',
        name: 'Test Descriptor',
        purpose: 'For testing purposes',
        constraints: Constraints(
          fields: [
            const Field(path: [r'$.credentialSubject.id']),
          ],
        ),
      );

      // Set up presentation definition
      presentationDefinition = PresentationDefinition(
        id: 'testDefinition',
        inputDescriptors: [inputDescriptor],
      );

      // Set up credential manifest
      when(() => credentialManifest.presentationDefinition)
          .thenReturn(presentationDefinition);
      when(() => credential.credentialManifest).thenReturn(credentialManifest);

      // Set up credential
      final mockCredentialPreview = MockCredential();
      final mockSubjectModel = MockCredentialSubjectModel();
      when(() => mockSubjectModel.credentialSubjectType)
          .thenReturn(CredentialSubjectType.defaultCredential);
      when(() => mockCredentialPreview.credentialSubjectModel)
          .thenReturn(mockSubjectModel);
      when(() => mockCredentialPreview.type)
          .thenReturn(['VerifiableCredential']);
      when(() => credential.credentialPreview)
          .thenReturn(mockCredentialPreview);
      when(() => credential.id).thenReturn('test-id');

      // Set up credential manifest pick cubit
      when(() => credentialManifestPickCubit.state).thenReturn(
        CredentialManifestPickState(
          filteredCredentialList: const [],
          selected: const [],
          presentationDefinition: presentationDefinition,
          isButtonEnabled: false,
        ),
      );

      // Set up credentials cubit
      when(() => credentialsCubit.state).thenReturn(
        const CredentialsState(
          status: CredentialsStatus.idle,
          credentials: [],
        ),
      );

      // Set up scan cubit
      when(() => scanCubit.state).thenReturn(
        const ScanState(
          status: ScanStatus.success,
        ),
      );

      // Set up QR code scan cubit
      when(() => qrCodeScanCubit.state).thenReturn(
        const QRCodeScanState(
          status: QrScanStatus.idle,
        ),
      );
    });

    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<LocalAuthApi>(
                create: (_) => MockLocalAuthApi(),
              ),
              RepositoryProvider<OIDC4VC>(
                create: (_) => MockOIDC4VC(),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ProfileCubit>.value(value: profileCubit),
                BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
                BlocProvider<ScanCubit>.value(value: scanCubit),
                BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
                BlocProvider<CredentialManifestPickCubit>.value(
                  value: credentialManifestPickCubit,
                ),
              ],
              child: Material(
                child: CredentialManifestOfferPickPage(
                  uri: Uri.parse('https://example.com'),
                  credential: credential,
                  issuer: issuer,
                  inputDescriptorIndex: 0,
                  credentialsToBePresented: const [],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CredentialManifestOfferPickPage), findsOneWidget);
    });
  });
}
