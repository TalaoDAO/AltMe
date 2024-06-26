import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:secure_storage/secure_storage.dart';

import '../../helpers/helpers.dart';

class MockProfleCubit extends MockCubit<ProfileState> implements ProfileCubit {
  @override
  final state = ProfileState(model: ProfileModel.empty());
}

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

class MockLocalAuthApi extends Mock implements LocalAuthApi {}

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

void main() {
  group('Pincode Page', () {
    final PinCodeViewCubit pinCodeViewCubit = PinCodeViewCubit();
    final MockNavigator navigator = MockNavigator();
    final MockSecureStorageProvider secureStorageProvider =
        MockSecureStorageProvider();
    final MockProfleCubit profleCubit = MockProfleCubit();
    final MockLocalAuthApi localAuthApi = MockLocalAuthApi();
    final MockFlavorCubit flavorCubit = MockFlavorCubit();

    setUpAll(() {
      when(() => secureStorageProvider.get(any())).thenAnswer((_) async => '');

      when(() => secureStorageProvider.set(any(), any()))
          .thenAnswer((_) async => Future<void>.value());

      when(navigator.canPop).thenReturn(true);
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});
      when(() => navigator.pushAndRemoveUntil<void>(any(), any()))
          .thenAnswer((_) async {});
      when(() => navigator.pushReplacement<void, void>(any()))
          .thenAnswer((_) async {});
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: Builder(
            builder: (context) => Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    PinCodePage.route(
                      isValidCallback: () {},
                      walletProtectionType: WalletProtectionType.FA2,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/pinCodePage'),
            ),
          ),
        ),
      ).called(1);
    });

    // testWidgets('renders PinCodePage', (tester) async {
    //   await tester.pumpApp(
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ProfileCubit>.value(value: profleCubit),
    //         BlocProvider<PinCodeViewCubit>.value(value: pinCodeViewCubit),
    //         BlocProvider<FlavorCubit>.value(value: flavorCubit),
    //       ],
    //       child: PinCodePage(
    //         isValidCallback: () {},
    //         walletProtectionType: WalletProtectionType.FA2,
    //         secureStorageProvider: secureStorageProvider,
    //         localAuthApi: localAuthApi,
    //       ),
    //     ),
    //   );
    //   expect(find.byType(PinCodeView), findsOneWidget);
    // });

    // testWidgets('renders UI correctly', (tester) async {
    //   await tester.pumpApp(
    //     MultiBlocProvider(
    //       providers: [
    //         BlocProvider<ProfileCubit>.value(value: profleCubit),
    //         BlocProvider<PinCodeViewCubit>.value(value: pinCodeViewCubit),
    //         BlocProvider<FlavorCubit>.value(value: flavorCubit),
    //       ],
    //       child: PinCodeView(
    //         isValidCallback: () {},
    //         walletProtectionType: WalletProtectionType.FA2,
    //         secureStorageProvider: secureStorageProvider,
    //         localAuthApi: localAuthApi,
    //         profileCubit: profleCubit,
    //       ),
    //     ),
    //   );
    //   expect(find.byType(BasePage), findsOneWidget);
    //   expect(find.byType(PinCodeWidget), findsOneWidget);
    // });
  });
}
