import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {}

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  final MockFlavorCubit mockFlavorCubit = MockFlavorCubit();
  final MockProfileCubit mockProfileCubit = MockProfileCubit();

  group('WalletLogo widget', () {
    testWidgets(
        'displays correct image for ProfileType.defaultOne in development',
        (WidgetTester tester) async {
      when(() => mockFlavorCubit.state).thenReturn(FlavorMode.development);
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(
          model: ProfileModel.defaultOne(
            polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
            walletType: WalletType.personal,
            walletProtectionType: WalletProtectionType.FA2,
            isDeveloperMode: true,
            clientId: 'clientId',
            clientSecret: 'clientSecret',
          ),
        ),
      );
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<FlavorCubit>(
                    create: (context) => mockFlavorCubit,
                  ),
                  BlocProvider<ProfileCubit>(
                    create: (context) => mockProfileCubit,
                  ),
                ],
                child: const WalletLogo(height: 100, width: 100),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image image = tester.widget(imageFinder);
      final AssetImage imageProvider = image.image as AssetImage;
      expect(imageProvider.assetName, ImageStrings.appLogoDev);
    });

    group('ProfileType.custom', () {
      testWidgets(
          'displays correct image for ProfileType.custom in development',
          (WidgetTester tester) async {
        when(() => mockFlavorCubit.state).thenReturn(FlavorMode.development);
        when(() => mockProfileCubit.state).thenReturn(
          ProfileState(model: ProfileModel.empty()),
        );
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<FlavorCubit>(
                      create: (context) => mockFlavorCubit,
                    ),
                    BlocProvider<ProfileCubit>(
                      create: (context) => mockProfileCubit,
                    ),
                  ],
                  child: const WalletLogo(height: 100, width: 100),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final imageFinder = find.byType(Image);
        expect(imageFinder, findsOneWidget);

        final Image image = tester.widget(imageFinder);
        final AssetImage imageProvider = image.image as AssetImage;
        expect(imageProvider.assetName, ImageStrings.appLogoDev);
      });

      testWidgets('displays correct image for ProfileType.custom in staging',
          (WidgetTester tester) async {
        when(() => mockFlavorCubit.state).thenReturn(FlavorMode.staging);
        when(() => mockProfileCubit.state).thenReturn(
          ProfileState(model: ProfileModel.empty()),
        );
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<FlavorCubit>(
                      create: (context) => mockFlavorCubit,
                    ),
                    BlocProvider<ProfileCubit>(
                      create: (context) => mockProfileCubit,
                    ),
                  ],
                  child: const WalletLogo(height: 100, width: 100),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final imageFinder = find.byType(Image);
        expect(imageFinder, findsOneWidget);

        final Image image = tester.widget(imageFinder);
        final AssetImage imageProvider = image.image as AssetImage;
        expect(imageProvider.assetName, ImageStrings.appLogoStage);
      });

      testWidgets('displays correct image for ProfileType.custom in production',
          (WidgetTester tester) async {
        when(() => mockFlavorCubit.state).thenReturn(FlavorMode.production);
        when(() => mockProfileCubit.state).thenReturn(
          ProfileState(model: ProfileModel.empty()),
        );
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<FlavorCubit>(
                      create: (context) => mockFlavorCubit,
                    ),
                    BlocProvider<ProfileCubit>(
                      create: (context) => mockProfileCubit,
                    ),
                  ],
                  child: const WalletLogo(height: 100, width: 100),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final imageFinder = find.byType(Image);
        expect(imageFinder, findsOneWidget);

        final Image image = tester.widget(imageFinder);
        final AssetImage imageProvider = image.image as AssetImage;
        expect(imageProvider.assetName, ImageStrings.appLogo);
      });
    });

    testWidgets('displays correct image for ProfileType.dutch in development',
        (WidgetTester tester) async {
      when(() => mockFlavorCubit.state).thenReturn(FlavorMode.development);
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(
          model: ProfileModel.dutch(
            polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
            walletType: WalletType.personal,
            walletProtectionType: WalletProtectionType.FA2,
            isDeveloperMode: true,
            clientId: 'clientId',
            clientSecret: 'clientSecret',
          ),
        ),
      );
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<FlavorCubit>(
                    create: (context) => mockFlavorCubit,
                  ),
                  BlocProvider<ProfileCubit>(
                    create: (context) => mockProfileCubit,
                  ),
                ],
                child: const WalletLogo(height: 100, width: 100),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image image = tester.widget(imageFinder);
      final AssetImage imageProvider = image.image as AssetImage;
      expect(imageProvider.assetName, ImageStrings.appLogoDev);
    });

    testWidgets('displays correct image for ProfileType.ebsiV3 in development',
        (WidgetTester tester) async {
      when(() => mockFlavorCubit.state).thenReturn(FlavorMode.development);
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(
          model: ProfileModel.ebsiV3(
            polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
            walletType: WalletType.personal,
            walletProtectionType: WalletProtectionType.FA2,
            isDeveloperMode: true,
            clientId: 'clientId',
            clientSecret: 'clientSecret',
          ),
        ),
      );
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<FlavorCubit>(
                    create: (context) => mockFlavorCubit,
                  ),
                  BlocProvider<ProfileCubit>(
                    create: (context) => mockProfileCubit,
                  ),
                ],
                child: const WalletLogo(height: 100, width: 100),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image image = tester.widget(imageFinder);
      final AssetImage imageProvider = image.image as AssetImage;
      expect(imageProvider.assetName, ImageStrings.ebsiLogo);
    });

    testWidgets(
        'displays correct image for '
        'ProfileType.owfBaselineProfile in development',
        (WidgetTester tester) async {
      when(() => mockFlavorCubit.state).thenReturn(FlavorMode.development);
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(
          model: ProfileModel.owfBaselineProfile(
            polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
            walletType: WalletType.personal,
            walletProtectionType: WalletProtectionType.FA2,
            isDeveloperMode: true,
            clientId: 'clientId',
            clientSecret: 'clientSecret',
          ),
        ),
      );
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<FlavorCubit>(
                    create: (context) => mockFlavorCubit,
                  ),
                  BlocProvider<ProfileCubit>(
                    create: (context) => mockProfileCubit,
                  ),
                ],
                child: const WalletLogo(height: 100, width: 100),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image image = tester.widget(imageFinder);
      final AssetImage imageProvider = image.image as AssetImage;
      expect(imageProvider.assetName, ImageStrings.owfBaselineProfileLogo);
    });

    testWidgets(
        'displays correct image for ProfileType.enterprise in development',
        (WidgetTester tester) async {
      when(() => mockFlavorCubit.state).thenReturn(FlavorMode.development);
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(
          model: ProfileModel(
            polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
            walletType: WalletType.personal,
            walletProtectionType: WalletProtectionType.pinCode,
            isDeveloperMode: false,
            profileType: ProfileType.enterprise,
            profileSetting: ProfileSetting(
              blockchainOptions: BlockchainOptions.initial(),
              discoverCardsOptions: DiscoverCardsOptions.initial(),
              generalOptions: GeneralOptions(
                walletType: WalletAppType.altme,
                companyName: '',
                companyWebsite: '',
                companyLogo: 'https://www.demo.com',
                tagLine: '',
                splashScreenTitle: '',
                profileName: '',
                profileVersion: '',
                published: DateTime.now(),
                profileId: '',
                customerPlan: '',
                primaryColor: '',
              ),
              helpCenterOptions: HelpCenterOptions.initial(),
              selfSovereignIdentityOptions:
                  SelfSovereignIdentityOptions.initial(),
              settingsMenu: SettingsMenu.initial(),
              version: '',
              walletSecurityOptions: WalletSecurityOptions.initial(),
            ),
          ),
        ),
      );
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<FlavorCubit>(
                    create: (context) => mockFlavorCubit,
                  ),
                  BlocProvider<ProfileCubit>(
                    create: (context) => mockProfileCubit,
                  ),
                ],
                child: const WalletLogo(height: 100, width: 100),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CachedImageFromNetwork), findsOneWidget);
    });
  });
}
