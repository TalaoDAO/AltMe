import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

void main() {
  late FlavorCubit mockFlavorCubit;

  setUpAll(() {
    mockFlavorCubit = MockFlavorCubit();
  });

  group('WalletLogo widget', () {
    testWidgets(
        'displays correct image for ProfileType.defaultOne in development',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return BlocProvider<FlavorCubit>(
                create: (context) => mockFlavorCubit,
                child: WalletLogo(
                  height: 100,
                  width: 100,
                  profileModel: ProfileModel.defaultOne(
                    polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
                    walletType: WalletType.personal,
                    walletProtectionType: WalletProtectionType.FA2,
                    isDeveloperMode: true,
                    clientId: 'clientId',
                    clientSecret: 'clientSecret',
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays correct image for ProfileType.custom in development',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return BlocProvider<FlavorCubit>(
                create: (context) => mockFlavorCubit,
                child: WalletLogo(
                  height: 100,
                  width: 100,
                  profileModel: ProfileModel.empty(),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays correct image for ProfileType.dutch in development',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return BlocProvider<FlavorCubit>(
                create: (context) => mockFlavorCubit,
                child: WalletLogo(
                  height: 100,
                  width: 100,
                  profileModel: ProfileModel.dutch(
                    polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
                    walletType: WalletType.personal,
                    walletProtectionType: WalletProtectionType.FA2,
                    isDeveloperMode: true,
                    clientId: 'clientId',
                    clientSecret: 'clientSecret',
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays correct image for ProfileType.ebsiV3 in development',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return BlocProvider<FlavorCubit>(
                create: (context) => mockFlavorCubit,
                child: WalletLogo(
                  height: 100,
                  width: 100,
                  profileModel: ProfileModel.ebsiV3(
                    polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
                    walletType: WalletType.personal,
                    walletProtectionType: WalletProtectionType.FA2,
                    isDeveloperMode: true,
                    clientId: 'clientId',
                    clientSecret: 'clientSecret',
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        'displays correct image for ProfileType.owfBaselineProfile in development',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return BlocProvider<FlavorCubit>(
                create: (context) => mockFlavorCubit,
                child: WalletLogo(
                  height: 100,
                  width: 100,
                  profileModel: ProfileModel.owfBaselineProfile(
                    polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
                    walletType: WalletType.personal,
                    walletProtectionType: WalletProtectionType.FA2,
                    isDeveloperMode: true,
                    clientId: 'clientId',
                    clientSecret: 'clientSecret',
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        'displays correct image for ProfileType.enterprise in development',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return BlocProvider<FlavorCubit>(
                create: (context) => mockFlavorCubit,
                child: WalletLogo(
                  height: 100,
                  width: 100,
                  profileModel: ProfileModel(
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
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CachedImageFromNetwork), findsOneWidget);
    });
  });
}
