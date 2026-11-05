import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/splash/bloclisteners/blocklisteners.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  group('credentialsBlocListener', () {
    late _MockCredentialsCubit credentialsCubit;
    late _MockProfileCubit profileCubit;

    setUp(() {
      credentialsCubit = _MockCredentialsCubit();
      profileCubit = _MockProfileCubit();
      when(
        () => profileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
    });

    tearDown(LoadingView().hide);

    Future<void> pumpWith(
      WidgetTester tester,
      List<CredentialsState> states,
    ) async {
      const initial = CredentialsState();
      whenListen(
        credentialsCubit,
        Stream.fromIterable(states),
        initialState: initial,
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider(create: (_) => FlavorCubit(FlavorMode.development)),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MultiBlocListener(
              listeners: [credentialsBlocListener],
              child: const Scaffold(body: SizedBox()),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('shows the loading view while credentials load', (
      tester,
    ) async {
      await pumpWith(tester, [const CredentialsState().loading()]);

      expect(find.byType(WalletLogo), findsOneWidget);
    });

    testWidgets('hides the loading view after a delete without a message', (
      tester,
    ) async {
      // A presented batch copy is deleted silently, e.g. at the end of an
      // mdoc proximity session.
      await pumpWith(tester, [
        const CredentialsState().loading(),
        const CredentialsState(status: CredentialsStatus.delete),
      ]);

      expect(find.byType(WalletLogo), findsNothing);
    });
  });
}
