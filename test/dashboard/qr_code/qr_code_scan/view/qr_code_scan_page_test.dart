import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:altme/scan/scan.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class _MockScanCubit extends MockCubit<ScanState> implements ScanCubit {}

class _MockCustomReaderRequestsCubit
    extends MockCubit<CustomReaderRequestsState>
    implements CustomReaderRequestsCubit {}

void main() {
  late _MockProfileCubit profileCubit;
  late _MockCredentialsCubit credentialsCubit;
  late _MockQRCodeScanCubit qrCodeScanCubit;
  late _MockScanCubit scanCubit;
  late _MockCustomReaderRequestsCubit customReaderRequestsCubit;

  void withProfile({required bool readerRequests}) {
    final model = ProfileModel.empty();
    when(() => profileCubit.state).thenReturn(
      ProfileState(
        model: model.copyWith(
          profileSetting: model.profileSetting.copyWith(
            readerRequests: readerRequests ? defaultReaderRequests : null,
          ),
        ),
      ),
    );
  }

  setUp(() {
    profileCubit = _MockProfileCubit();
    credentialsCubit = _MockCredentialsCubit();
    qrCodeScanCubit = _MockQRCodeScanCubit();
    scanCubit = _MockScanCubit();
    customReaderRequestsCubit = _MockCustomReaderRequestsCubit();
    when(
      () => customReaderRequestsCubit.state,
    ).thenReturn(const CustomReaderRequestsState());
    when(() => credentialsCubit.state).thenReturn(const CredentialsState());
    when(() => qrCodeScanCubit.state).thenReturn(const QRCodeScanState());
    when(() => scanCubit.state).thenReturn(const ScanState());
  });

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>.value(value: profileCubit),
        BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
        BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
        BlocProvider<ScanCubit>.value(value: scanCubit),
        BlocProvider<CustomReaderRequestsCubit>.value(
          value: customReaderRequestsCubit,
        ),
      ],
      // The Scan tab needs a camera: start on the Present tab.
      child: const QrCodeScanPage(initialTab: ScanPageTab.present),
    ),
  );

  group('QrCodeScanPage', () {
    testWidgets('offers the Read tab with the profile reader requests', (
      tester,
    ) async {
      withProfile(readerRequests: true);
      await pump(tester);

      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      expect(find.byIcon(Icons.contactless_outlined), findsWidgets);
      expect(find.byIcon(Icons.fact_check_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.fact_check_outlined));
      await tester.pump();

      expect(find.byType(MdocReaderRequestsView), findsOneWidget);
      expect(find.text('PID'), findsOneWidget);
      expect(find.text('mDL'), findsOneWidget);
      expect(find.text('My requests'), findsOneWidget);
    });

    testWidgets('has no Read tab without reader requests', (tester) async {
      withProfile(readerRequests: false);
      await pump(tester);

      expect(find.byIcon(Icons.fact_check_outlined), findsNothing);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });

    testWidgets('says so when no attestation can be presented in person', (
      tester,
    ) async {
      withProfile(readerRequests: false);
      await pump(tester);

      expect(find.byType(MdocPresentView), findsOneWidget);
      expect(
        find.text(
          'No attestation in your wallet can be shown to a reader in person.',
        ),
        findsOneWidget,
      );
    });
  });
}
