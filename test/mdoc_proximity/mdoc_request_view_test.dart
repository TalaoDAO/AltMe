import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;
}

void main() {
  // A stored mDL, so the attestation card renders as in the wallet.
  final fixture =
      jsonDecode(
            File(
              'test/dashboard/home/tab_bar/credentials/detail/view/fixtures/'
              'mdl_with_portrait.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;

  CredentialModel mdoc(String id, String docType, Map<String, dynamic> ns) =>
      CredentialModel.fromJson({
        ...fixture,
        'id': id,
        'data': {
          ...fixture['data'] as Map<String, dynamic>,
          'issuerSigned': 'issuer-signed-$id',
          'docType': docType,
          'credentialSubject': ns,
        },
        'credentialSupported': null,
        'keyId': 'mdoc_$id',
      });

  final pid = mdoc('pid', eudiPidDocType, {
    eudiPidDocType: {'family_name': 'DOE', 'given_name': 'JANE'},
  });
  final otherPid = mdoc('pid-2', eudiPidDocType, {
    eudiPidDocType: {'family_name': 'ROE', 'given_name': 'RICHARD'},
  });

  const documents = [
    ProximityDocumentRequest(
      docType: eudiPidDocType,
      nameSpaces: {
        eudiPidDocType: {'family_name': false, 'birth_date': false},
      },
    ),
    ProximityDocumentRequest(
      docType: 'org.iso.18013.5.1.mDL',
      nameSpaces: {
        'org.iso.18013.5.1': {'portrait': false},
      },
    ),
  ];

  late List<ProximityDisclosure>? shared;
  late bool declined;
  late _MockProfileCubit profileCubit;
  late _MockLangCubit langCubit;

  setUp(() {
    final profileModel = _MockProfileModel();
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
    when(() => profileModel.profileType).thenReturn(ProfileType.defaultOne);
    profileCubit = _MockProfileCubit();
    when(() => profileCubit.state).thenReturn(_FakeProfileState(profileModel));
    langCubit = _MockLangCubit();
    when(() => langCubit.state).thenReturn(
      const LangState(locale: Locale('en'), languageType: LanguageType.phone),
    );
  });

  Future<void> pump(
    WidgetTester tester, {
    required Map<String, List<CredentialModel>> candidates,
    List<ProximityDocumentRequest> requested = documents,
    ProximityReader reader = const ProximityReader(),
  }) async {
    shared = null;
    declined = false;
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<LangCubit>.value(value: langCubit),
        ],
        child: Scaffold(
          body: MdocRequestView(
            documents: requested,
            candidates: candidates,
            reader: reader,
            onShare: (disclosures) => shared = disclosures,
            onDecline: () => declined = true,
          ),
        ),
      ),
    );
  }

  /// Shown values are in selectable text, with their label.
  Finder value(String text) => find.textContaining(text);

  group('MdocRequestView', () {
    testWidgets('names the attestation answering each requested document', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
          'org.iso.18013.5.1.mDL': [],
        },
      );

      // The PID answers with the wallet's attestation, the mDL with none.
      expect(find.byType(CredentialDisplay), findsOneWidget);
      expect(find.byIcon(Icons.block), findsOneWidget);
      expect(find.text('org.iso.18013.5.1.mDL'), findsOneWidget);
      expect(
        find.text("You don't have the requested attestation"),
        findsOneWidget,
      );
      expect(value('DOE'), findsWidgets);
      expect(
        find.byType(DropdownButtonFormField<CredentialModel>),
        findsNothing,
      );
    });

    testWidgets('shares only what the answering attestation holds', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
          'org.iso.18013.5.1.mDL': [],
        },
      );

      await tester.tap(find.byType(MyElevatedButton));

      expect(shared, [
        ProximityDisclosure(
          mdoc: pid.proximityMdoc,
          elements: const {
            eudiPidDocType: ['family_name'],
          },
        ),
      ]);
    });

    testWidgets('shares one disclosure per document it can answer', (
      tester,
    ) async {
      final mdl = mdoc('mdl', 'org.iso.18013.5.1.mDL', {
        'org.iso.18013.5.1': {'portrait': 'bytes'},
      });
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
          'org.iso.18013.5.1.mDL': [mdl],
        },
      );

      await tester.tap(find.byType(MyElevatedButton));

      expect(shared?.map((disclosure) => disclosure.mdoc.id), ['pid', 'mdl']);
    });

    testWidgets('leaves out an element the user unticks', (tester) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
        },
        requested: [documents.first],
      );

      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      // The only element held is unticked: nothing left to share.
      final button = tester.widget<MyElevatedButton>(
        find.byType(MyElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('lets the user choose between two attestations of a type', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid, otherPid],
        },
        requested: [documents.first],
      );

      expect(value('DOE'), findsWidgets);
      expect(value('ROE'), findsNothing);

      await tester.tap(find.byType(DropdownButtonFormField<CredentialModel>));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('(2)').last);
      await tester.pumpAndSettle();

      expect(value('ROE'), findsWidgets);
      expect(value('DOE'), findsNothing);

      await tester.tap(find.byType(MyElevatedButton));

      expect(shared, [
        ProximityDisclosure(
          mdoc: otherPid.proximityMdoc,
          elements: const {
            eudiPidDocType: ['family_name'],
          },
        ),
      ]);
    });

    testWidgets('cannot share when no document can be answered', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {eudiPidDocType: [], 'org.iso.18013.5.1.mDL': []},
      );

      final button = tester.widget<MyElevatedButton>(
        find.byType(MyElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('names a reader the trusted list verifies', (tester) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
        },
        reader: const ProximityReader(name: 'City Hall', isTrusted: true),
      );

      expect(find.text('Requested by'), findsOneWidget);
      expect(find.text('City Hall'), findsOneWidget);
      expect(find.text('Verified organisation'), findsOneWidget);
    });

    testWidgets('warns about a reader that did not sign', (tester) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
        },
      );

      expect(find.text('Unknown reader'), findsOneWidget);
      expect(find.text('Organisation not verified'), findsOneWidget);
    });

    testWidgets('declines', (tester) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
        },
      );

      await tester.tap(find.byType(MyOutlinedButton));

      expect(declined, isTrue);
      expect(shared, isNull);
    });
  });
}
