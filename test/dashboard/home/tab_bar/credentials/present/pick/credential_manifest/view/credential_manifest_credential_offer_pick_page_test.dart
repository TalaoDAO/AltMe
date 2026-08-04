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

import '../../../../../../../../golden_test_config.dart';
import '../../../../../../../../test_objects.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockCredentialManifestPickCubit
    extends MockCubit<CredentialManifestPickState>
    implements CredentialManifestPickCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class MockScanCubit extends MockCubit<ScanState> implements ScanCubit {}

class MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

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
  setUpAll(() async {
    registerFallbackValue(
      const CredentialManifestPickState(filteredCredentialList: []),
    );
    registerFallbackValue(
      const CredentialsState(status: CredentialsStatus.idle, credentials: []),
    );
    registerFallbackValue(const ScanState());
    registerFallbackValue(MockProfileState(model: MockProfileModel()));
    registerFallbackValue(Uri());
    registerFallbackValue(MockIssuer());
    registerFallbackValue(MockCredentialModel());
    registerFallbackValue(
      InputDescriptor(
        id: '1',
        constraints: Constraints(fields: []),
      ),
    );
    registerFallbackValue(
      PresentationDefinition(id: 'test', inputDescriptors: []),
    );
    registerFallbackValue(MockQRCodeScanCubit());
    registerFallbackValue(const QRCodeScanState());
    await loadAppFonts();
  });

  group('CredentialManifestOfferPickPage', () {
    late CredentialManifestPickCubit credentialManifestPickCubit;
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
      when(
        () => localAuthApi.authenticate(
          localizedReason: any(named: 'localizedReason'),
        ),
      ).thenAnswer((_) async => true);

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
        constraints: Constraints(
          fields: [
            const Field(path: [r'$.credentialSubject.id'], optional: false),
          ],
        ),
      );

      // Create presentation definition
      presentationDefinition = PresentationDefinition(
        id: 'testDefinition',
        inputDescriptors: [inputDescriptor],
      );

      // Create credential manifest
      credentialManifest = MockCredentialManifest();
      when(
        () => credentialManifest.presentationDefinition,
      ).thenReturn(presentationDefinition);

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
      when(
        () => mockSubjectModel.credentialSubjectType,
      ).thenReturn(CredentialSubjectType.defaultCredential);
      when(
        () => mockCredentialPreview.credentialSubjectModel,
      ).thenReturn(mockSubjectModel);
      when(
        () => mockCredentialPreview.type,
      ).thenReturn(['VerifiableCredential']);
      when(
        () => credential.credentialPreview,
      ).thenReturn(mockCredentialPreview);
      when(
        () => testCredential.credentialPreview,
      ).thenReturn(mockCredentialPreview);

      // Initialize empty list of credentials
      credentialsToBePresented = [];

      // Set up credential manifest pick cubit state
      when(() => credentialManifestPickCubit.state).thenReturn(
        CredentialManifestPickState(
          filteredCredentialList: [TEST_CREDENTIAL],
          selected: const [],
          presentationDefinition: presentationDefinition,
          isButtonEnabled: true,
        ),
      );

      when(() => credentialsCubit.state).thenReturn(
        CredentialsState(
          status: CredentialsStatus.idle,
          credentials: [TEST_CREDENTIAL],
        ),
      );

      when(
        () => scanCubit.state,
      ).thenReturn(const ScanState(status: ScanStatus.success));

      // Setup ScanCubit stubs
      when(
        () => scanCubit.credentialOfferOrPresent(
          uri: any(named: 'uri'),
          credentialModel: any(named: 'credentialModel'),
          keyId: any(named: 'keyId'),
          credentialsToBePresented: any(named: 'credentialsToBePresented'),
          issuer: any(named: 'issuer'),
          qrCodeScanCubit: any(named: 'qrCodeScanCubit'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => scanCubit.sendErrorToServer(
          uri: any(named: 'uri'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async {});

      // Setup QR code scan cubit
      when(
        () => qrCodeScanCubit.state,
      ).thenReturn(const QRCodeScanState(status: QrScanStatus.idle));
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
            RepositoryProvider<LocalAuthApi>(create: (_) => localAuthApi),
            RepositoryProvider<OIDC4VC>(create: (_) => MockOIDC4VC()),
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
              child: CredentialManifestOfferPickView(
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

    void testWithDevices(
      String description,
      Future<void> Function(WidgetTester tester, DeviceScreenSize device)
      callback,
    ) {
      for (final device in phoneScreenSizes) {
        testWidgets('$description on ${device.name}', (
          WidgetTester tester,
        ) async {
          // Set the surface size for the test
          await tester.binding.setSurfaceSize(device.size);
          tester.view.devicePixelRatio = device.devicePixelRatio;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await callback(tester, device);

          // Reset the surface size
          await tester.binding.setSurfaceSize(null);
        });
      }
    }

    testWithDevices('renders without crashing', (tester, device) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: false,
          ),
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: true,
          ),
        ]),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/renders_without_crashing_${device.name}.png',
        ),
      );
    });

    testWithDevices('Displays purpose text from input descriptor', (
      tester,
      device,
    ) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: false,
          ),
        ]),
      );
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/display_purpose${device.name}.png',
        ),
      );

      expect(
        find.text(inputDescriptor.purpose ?? ''),
        findsOneWidget,
        reason: 'Purpose text from input descriptor should be displayed',
      );
    });

    testWithDevices('displays credential list item', (tester, device) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: false,
          ),
        ]),
      );
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/display_credential_list_item_${device.name}.png',
        ),
      );

      expect(find.byType(CredentialsListPageItem), findsOneWidget);
    });

    testWithDevices('tapping credential item calls toggle on cubit', (
      tester,
      device,
    ) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: false,
          ),
        ]),
      );
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/tap_credential_call_toggle_${device.name}.png',
        ),
      );

      await tester.tap(find.byType(CredentialsListPageItem).first);
      await tester.pump();

      verify(
        () => credentialManifestPickCubit.toggle(
          index: 0,
          inputDescriptor: any(named: 'inputDescriptor'),
          isVcSdJWT: any(named: 'isVcSdJWT'),
        ),
      ).called(1);
    });

    testWithDevices('continue button is disabled when no selection', (
      tester,
      device,
    ) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: false,
          ),
        ]),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/continue_button_disabled_${device.name}.png',
        ),
      );

      final elevatedButtonFinder = find.byType(MyElevatedButton);
      expect(elevatedButtonFinder, findsOneWidget);

      final button = tester.widget<MyElevatedButton>(elevatedButtonFinder);
      expect(button.onPressed, isNull);
    });

    testWithDevices('continue button is enabled when credential is selected', (
      tester,
      device,
    ) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: true,
          ),
        ]),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/continue_button_enabled_${device.name}.png',
        ),
      );

      final elevatedButtonFinder = find.byType(MyElevatedButton);
      expect(elevatedButtonFinder, findsOneWidget);

      final button = tester.widget<MyElevatedButton>(elevatedButtonFinder);
      expect(button.onPressed, isNotNull);
    });

    testWithDevices('tapping continue button calls credentialOfferOrPresent', (
      tester,
      device,
    ) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: true,
          ),
        ]),
      );

      final profileSetting = ProfileSetting(
        walletSecurityOptions: WalletSecurityOptions.initial().copyWith(
          secureSecurityAuthenticationWithPinCode: false,
        ),
        selfSovereignIdentityOptions: SelfSovereignIdentityOptions.initial(),
        generalOptions: GeneralOptions.empty(),
        helpCenterOptions: HelpCenterOptions.initial(),
        settingsMenu: SettingsMenu.initial(),
        version: '1.0.0',
      );

      when(() => profileModel.profileSetting).thenReturn(profileSetting);

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MyElevatedButton));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/continue_calls_credentialOfferOrPresent_${device.name}.png',
        ),
      );

      verify(
        () => scanCubit.credentialOfferOrPresent(
          uri: any(named: 'uri'),
          credentialModel: any(named: 'credentialModel'),
          keyId: any(named: 'keyId'),
          credentialsToBePresented: any(named: 'credentialsToBePresented'),
          issuer: any(named: 'issuer'),
          qrCodeScanCubit: any(named: 'qrCodeScanCubit'),
        ),
      ).called(1);
    });

    testWithDevices('displays RequiredCredentialNotFound when list is empty', (
      tester,
      device,
    ) async {
      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: const [],
            selected: const [],
            presentationDefinition: presentationDefinition,
            isButtonEnabled: false,
          ),
        ]),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/required_credential_not_found_${device.name}.png',
        ),
      );

      expect(find.byType(RequiredCredentialNotFound), findsOneWidget);
    });

    testWithDevices('button shows Skip and is enabled for optional descriptor', (
      tester,
      device,
    ) async {
      final optionalInputDescriptor = InputDescriptor(
        id: '2',
        constraints: Constraints(
          fields: [
            const Field(path: [r'$.credentialSubject.id'], optional: true),
          ],
        ),
      );

      final optionalPresentationDefinition = PresentationDefinition(
        id: 'optionalDefinition',
        inputDescriptors: [optionalInputDescriptor],
      );

      whenListen(
        credentialManifestPickCubit,
        Stream.fromIterable([
          CredentialManifestPickState(
            filteredCredentialList: [TEST_CREDENTIAL],
            selected: const [],
            presentationDefinition: optionalPresentationDefinition,
            isButtonEnabled: true,
          ),
        ]),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: device.size,
            devicePixelRatio: device.devicePixelRatio,
          ),
          child: buildSubject(),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CredentialManifestOfferPickView),
        matchesGoldenFile(
          'goldens/credential_manifest_offer_pick_page/optional_descriptor_skip_${device.name}.png',
        ),
      );

      expect(find.text('SKIP'), findsOneWidget);

      final elevatedButtonFinder = find.byType(MyElevatedButton);
      final button = tester.widget<MyElevatedButton>(elevatedButtonFinder);
      expect(button.onPressed, isNotNull);
    });
  });
}
