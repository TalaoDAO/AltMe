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

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockCredentialManifestPickCubit
    extends MockCubit<CredentialManifestPickState>
    implements CredentialManifestPickCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class MockScanCubit extends MockCubit<ScanState> implements ScanCubit {
  @override
  Future<void> sendErrorToServer({
    required Uri uri,
    required Map<String, dynamic> data,
  }) async {
    // Mock implementation for testing
    return;
  }

  @override
  Future<void> credentialOfferOrPresent({
    required Uri uri,
    required CredentialModel credentialModel,
    required String keyId,
    required List<CredentialModel>? credentialsToBePresented,
    required Issuer issuer,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    // Mock implementation for testing
    return;
  }
}

class MockQRCodeScanCubit extends Mock implements QRCodeScanCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockLocalAuthApi extends Mock implements LocalAuthApi {}

class MockOIDC4VC extends Mock implements OIDC4VC {}

// Mock classes for testing
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
  // Enable mocking of named constructors
  setUpAll(() {
    registerFallbackValue(const CredentialManifestPickState(
      filteredCredentialList: [],
    ),);
    registerFallbackValue(const CredentialsState(
      status: CredentialsStatus.idle,
      credentials: [],
    ),);
    registerFallbackValue(const ScanState());
    registerFallbackValue(MockProfileState(model: MockProfileModel()));
    registerFallbackValue(Uri());
    registerFallbackValue(MockIssuer());
    registerFallbackValue(MockCredentialModel());
    registerFallbackValue(InputDescriptor(
      id: '1',
      constraints: Constraints(fields: []),
    ),);
    registerFallbackValue(PresentationDefinition(
      id: 'test',
      inputDescriptors: [],
    ),);
    registerFallbackValue(MockQRCodeScanCubit());
  });

  group('CredentialManifestOfferPickPage', () {
    late MockCredentialManifestPickCubit credentialManifestPickCubit;
    late MockCredentialsCubit credentialsCubit;
    late MockProfileCubit profileCubit;
    late MockScanCubit scanCubit;
    late MockQRCodeScanCubit qrCodeScanCubit;
    late NavigatorObserver mockNavigatorObserver;
    late Uri uri;
    late CredentialModel credential;
    late Issuer issuer;
    late List<CredentialModel> credentialsToBePresented;
    late InputDescriptor inputDescriptor;
    late PresentationDefinition presentationDefinition;
    late MockProfileModel profileModel;
    late MockProfileState profileState;
    late MockCredentialManifest credentialManifest;
    late OrganizationInfo organizationInfo;
    late CredentialModel testCredential;
    late MockLocalAuthApi localAuthApi;

    setUp(() {
      credentialManifestPickCubit = MockCredentialManifestPickCubit();
      credentialsCubit = MockCredentialsCubit();
      profileCubit = MockProfileCubit();
      scanCubit = MockScanCubit();
      qrCodeScanCubit = MockQRCodeScanCubit();
      mockNavigatorObserver = MockNavigatorObserver();
      localAuthApi = MockLocalAuthApi();

      // Mock LocalAuthApi authenticate to return true for security checks
      when(() => localAuthApi.authenticate(
              localizedReason: any(named: 'localizedReason'),),)
          .thenAnswer((_) async => true);

      // Setup profile and state
      profileModel = MockProfileModel();
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
      when(() => profileModel.isDeveloperMode).thenReturn(false);
      when(() => profileModel.profileType).thenReturn(ProfileType.ebsiV3);
      profileState = MockProfileState(model: profileModel);
      when(() => profileCubit.state).thenReturn(profileState);

      // Setup URI and credential data
      uri = Uri.parse('https://example.com');

      // Create mock organization info
      organizationInfo = MockOrganizationInfo();
      when(() => organizationInfo.website).thenReturn('example.com');

      // Create issuer with organization info
      issuer = MockIssuer();
      when(() => issuer.preferredName).thenReturn('Test Issuer');
      when(() => issuer.organizationInfo).thenReturn(organizationInfo);

      // Create input descriptor with purpose
      inputDescriptor = InputDescriptor(
        id: '1',
        name: 'Test Descriptor',
        purpose: 'For testing purposes',
        constraints: Constraints(fields: [
          const Field(
            path: [r'$.credentialSubject.id'],
            optional: false,
          ),
        ],),
      );

      // Create presentation definition
      presentationDefinition = PresentationDefinition(
        id: 'testDefinition',
        inputDescriptors: [inputDescriptor],
      );

      // Create credential manifest
      credentialManifest = MockCredentialManifest();
      when(() => credentialManifest.presentationDefinition)
          .thenReturn(presentationDefinition);

      // Create mock credential with credential manifest
      credential = MockCredentialModel();
      when(() => credential.id).thenReturn('test-id');
      when(() => credential.credentialManifest).thenReturn(credentialManifest);

      // Create additional test credential for the list
      testCredential = MockCredentialModel();
      when(() => testCredential.id).thenReturn('test-credential-id');
      when(() => testCredential.getName).thenReturn('Test Credential');
      when(() => testCredential.image).thenReturn('assets/image/logo.png');
      when(() => testCredential.getFormat).thenReturn('jwt_vc');

      // Create mock credential preview for the credential
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
      when(() => testCredential.credentialPreview)
          .thenReturn(mockCredentialPreview);

      // Initialize empty list of credentials
      credentialsToBePresented = [];

      // Set up credential manifest pick cubit state
      when(() => credentialManifestPickCubit.state).thenReturn(
        CredentialManifestPickState(
          filteredCredentialList: [testCredential],
          selected: const [],
          presentationDefinition: presentationDefinition,
          isButtonEnabled: false,
        ),
      );

      when(() => credentialsCubit.state).thenReturn(
        const CredentialsState(
          status: CredentialsStatus.idle,
          credentials: [],
        ),
      );

      when(() => scanCubit.state).thenReturn(
        const ScanState(
          status: ScanStatus.success,
        ),
      );

      // Setup QR code scan cubit
      when(() => qrCodeScanCubit.state).thenReturn(
        const QRCodeScanState(
          status: QrScanStatus.idle,
        ),
      );
    });

    Widget buildSubject() {
      return MaterialApp(
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
              create: (_) => localAuthApi,
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
                  value: credentialManifestPickCubit,),
            ],
            child: Material(
              child: CredentialManifestOfferPickPage(
                uri: uri,
                credential: credential,
                issuer: issuer,
                inputDescriptorIndex: 0,
                credentialsToBePresented: credentialsToBePresented,
              ),
            ),
          ),
        ),
        navigatorObservers: [mockNavigatorObserver],
      );
    }

    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      // Initial render should not crash
      expect(find.byType(CredentialManifestOfferPickPage), findsOneWidget);
      // Just pump a few frames to get past initial animations
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays purpose text from input descriptor',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Verify that the purpose text is shown somewhere in the widget tree
      expect(
        find.text(inputDescriptor.purpose ?? ''),
        findsOneWidget,
        reason: 'Purpose text from input descriptor should be displayed',
      );
    });

    testWidgets('displays credential list item', (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Check that the page contains the right widget type
      expect(find.byType(CredentialsListPageItem), findsOneWidget);
    });

    testWidgets('tapping credential item calls toggle on cubit',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Find and tap the first credential item widget
      await tester.tap(find.byType(CredentialsListPageItem).first);
      await tester.pump();

      // Verify toggle was called with the correct parameters
      verify(() => credentialManifestPickCubit.toggle(
            index: 0,
            inputDescriptor: any(named: 'inputDescriptor'),
            isVcSdJWT: any(named: 'isVcSdJWT'),
          ),).called(1);
    });

    testWidgets('continue button is initially disabled when no selection',
        (WidgetTester tester) async {
      // Setup state with no selected credential and button disabled
      when(() => credentialManifestPickCubit.state).thenReturn(
        CredentialManifestPickState(
          filteredCredentialList: [testCredential],
          selected: const [],
          presentationDefinition: presentationDefinition,
          isButtonEnabled: false,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Find the button - first check if it exists
      final elevatedButtonFinder = find.byType(MyElevatedButton);
      expect(elevatedButtonFinder, findsOneWidget);

      // Verify the button is disabled (opacity is applied or onPressed is null)
      final button = tester.widget<MyElevatedButton>(elevatedButtonFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets('continue button is enabled when credential is selected',
        (WidgetTester tester) async {
      // Setup state with a selected credential and button enabled
      when(() => credentialManifestPickCubit.state).thenReturn(
        CredentialManifestPickState(
          filteredCredentialList: [testCredential],
          selected: const [0],
          presentationDefinition: presentationDefinition,
          isButtonEnabled: true,
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Find the button
      final elevatedButtonFinder = find.byType(MyElevatedButton);
      expect(elevatedButtonFinder, findsOneWidget);

      // Verify the button is enabled
      final button = tester.widget<MyElevatedButton>(elevatedButtonFinder);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('tapping continue button calls credentialOfferOrPresent',
        (WidgetTester tester) async {
      // Setup state with a selected credential and button enabled
      when(() => credentialManifestPickCubit.state).thenReturn(
        CredentialManifestPickState(
          filteredCredentialList: [testCredential],
          selected: const [0],
          presentationDefinition: presentationDefinition,
          isButtonEnabled: true,
        ),
      );

      // Set security check to false to skip pin code authentication
      when(() => profileModel.profileSetting.walletSecurityOptions
          .secureSecurityAuthenticationWithPinCode,).thenReturn(false);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Find and tap the enabled button
      await tester.tap(find.byType(MyElevatedButton));
      await tester.pumpAndSettle();

      // Verify credential offer/present method was called
      verify(() => scanCubit.credentialOfferOrPresent(
            uri: any(named: 'uri'),
            credentialModel: any(named: 'credentialModel'),
            keyId: any(named: 'keyId'),
            credentialsToBePresented: any(named: 'credentialsToBePresented'),
            issuer: any(named: 'issuer'),
            qrCodeScanCubit: any(named: 'qrCodeScanCubit'),
          ),).called(1);
    });
  });
}
