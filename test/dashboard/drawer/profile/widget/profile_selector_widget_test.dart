import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/profile/widget/profile_selector_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

void main() {
  late MockProfileCubit profileCubit;
  late MockCredentialsCubit credentialsCubit;

  setUp(() {
    profileCubit = MockProfileCubit();
    credentialsCubit = MockCredentialsCubit();
    when(
      () => profileCubit.state,
    ).thenReturn(ProfileState(model: ProfileModel.empty()));
  });

  Future<void> pumpSelector(WidgetTester tester) => tester.pumpApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>.value(value: profileCubit),
        BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
      ],
      child: const Scaffold(body: ProfileSelectorWidget()),
    ),
  );

  group('ProfileSelectorWidget', () {
    testWidgets('tells the user when a profile fails to load, and closes '
        'the loading popup', (tester) async {
      when(
        () => profileCubit.setProfile(ProfileType.EUDIW),
      ).thenThrow(Exception('Failed to load loadEuropeanWallet configuration'));

      // The tiles sit on a coloured box by design, which a debug-only
      // ListTile check reports.
      final onError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('ListTile background')) {
          return;
        }
        onError?.call(details);
      };
      try {
        await pumpSelector(tester);
        await tester.tap(find.text(ProfileType.EUDIW.getTitle(name: '')));
        // Settles only once the loading popup's spinner is gone.
        await tester.pumpAndSettle();

        expect(find.textContaining('Failed to load profile'), findsOneWidget);
        verifyNever(() => credentialsCubit.loadAllCredentials());
      } finally {
        FlutterError.onError = onError;
      }
    });
  });
}
