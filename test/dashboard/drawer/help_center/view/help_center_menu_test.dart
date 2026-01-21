import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../helpers/helpers.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

void main() {
  late MockProfileCubit mockProfileCubit;
  late FlavorCubit mockFlavorCubit;
  late MockNavigator navigator;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockProfileCubit = MockProfileCubit();
    mockFlavorCubit = MockFlavorCubit();
    navigator = MockNavigator();
    when(navigator.canPop).thenReturn(true);

    when(() => navigator.push<void>(any())).thenAnswer((_) async {});
  });

  group('Help Center Menu Test', () {
    testWidgets('renders HelpCenterView', (tester) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
            BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
          ],
          child: const HelpCenterMenu(),
        ),
      );

      expect(find.byType(HelpCenterView), findsOneWidget);
    });

    testWidgets('renders basic UI correctly', (tester) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
            BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
          ],
          child: HelpCenterView(profileCubit: mockProfileCubit),
        ),
      );
      expect(find.byType(BasePage), findsOneWidget);
      expect(find.byType(BackLeadingButton), findsOneWidget);
    });

    testWidgets(
      'navigates to ContactUsPage when displayEmailSupport is enabled and '
      'user taps "sendAnEmail"',
      (tester) async {
        when(
          () => mockProfileCubit.state,
        ).thenReturn(ProfileState(model: ProfileModel.empty()));

        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
                BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
              ],
              child: HelpCenterView(profileCubit: mockProfileCubit),
            ),
          ),
        );

        expect(find.text('Send an email'), findsOneWidget);

        await tester.tap(find.text('Send an email'));
        await tester.pumpAndSettle();

        verify(
          () => navigator.push<void>(
            any(that: isRoute<void>(whereName: equals('/ContactUsPage'))),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'navigates to ContactUsPage when displayEmailSupport is enabled and '
      'user taps "sendAnEmail"',
      (tester) async {
        when(
          () => mockProfileCubit.state,
        ).thenReturn(ProfileState(model: ProfileModel.empty()));

        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
                BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
              ],
              child: HelpCenterView(profileCubit: mockProfileCubit),
            ),
          ),
        );

        expect(find.text('Send an email'), findsOneWidget);

        await tester.tap(find.text('Send an email'));
        await tester.pumpAndSettle();

        verify(
          () => navigator.push<void>(
            any(that: isRoute<void>(whereName: equals('/ContactUsPage'))),
          ),
        ).called(1);
      },
    );
  });
}
