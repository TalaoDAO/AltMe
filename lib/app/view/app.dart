// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/src/view/page_not_found.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/enterprise.dart';
import 'package:altme/flavor/cubit/flavor_cubit.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/kyc_verification/cubit/kyc_verification_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/matrix_notification/cubit/matrix_notification_cubit.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/route/route.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:altme/theme/theme_cubit.dart';
import 'package:altme/theme/theme_repository.dart';

import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.flavorMode = FlavorMode.production,
    required this.themeRepository,
  });

  final FlavorMode flavorMode;
  final ThemeRepository themeRepository;

  @override
  Widget build(BuildContext context) {
    final secureStorageProvider = getSecureStorage;
    return RepositoryProvider.value(
      value: themeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(
              themeRepository: context.read<ThemeRepository>(),
            )..getCurrentTheme(),
          ),
          BlocProvider<FlavorCubit>(
            create: (context) => FlavorCubit(flavorMode),
          ),
          BlocProvider<LangCubit>(
            create: (context) =>
                LangCubit(secureStorageProvider: getSecureStorage),
          ),
          BlocProvider<RouteCubit>(create: (context) => RouteCubit()),
          BlocProvider<BeaconCubit>(
            create: (context) => BeaconCubit(beacon: Beacon()),
          ),
          BlocProvider<DeepLinkCubit>(create: (context) => DeepLinkCubit()),
          BlocProvider<QueryByExampleCubit>(
            create: (context) => QueryByExampleCubit(),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              secureStorageProvider: secureStorageProvider,
              oidc4vc: OIDC4VC(),
              didKitProvider: DIDKitProvider(),
              langCubit: context.read<LangCubit>(),
              jwtDecode: JWTDecode(),
            ),
          ),
          BlocProvider<AdvanceSettingsCubit>(
            create: (context) {
              return AdvanceSettingsCubit(
                secureStorageProvider: getSecureStorage,
              );
            },
          ),
          BlocProvider(
            create: (context) => KycVerificationCubit(
              profileCubit: context.read<ProfileCubit>(),
              client: DioClient(
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
            ),
          ),
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(
              client: DioClient(
                baseUrl: Urls.issuerBaseUrl,
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
              secureStorageProvider: secureStorageProvider,
              oidc4vc: OIDC4VC(),
              didKitProvider: DIDKitProvider(),
              profileCubit: context.read<ProfileCubit>(),
            ),
          ),
          BlocProvider<OnboardingCubit>(
            create: (context) => OnboardingCubit(),
          ),
          BlocProvider<WalletCubit>(
            lazy: false,
            create: (context) => WalletCubit(
              secureStorageProvider: secureStorageProvider,
              homeCubit: context.read<HomeCubit>(),
              keyGenerator: KeyGenerator(),
            ),
          ),
          BlocProvider<WalletConnectCubit>(
            create: (context) => WalletConnectCubit(
              secureStorageProvider: secureStorageProvider,
              connectedDappRepository:
                  ConnectedDappRepository(secureStorageProvider),
              routeCubit: context.read<RouteCubit>(),
              walletCubit: context.read<WalletCubit>(),
            ),
          ),
          BlocProvider<CredentialsCubit>(
            lazy: false,
            create: (context) => CredentialsCubit(
              credentialsRepository:
                  CredentialsRepository(secureStorageProvider),
              secureStorageProvider: secureStorageProvider,
              keyGenerator: KeyGenerator(),
              didKitProvider: DIDKitProvider(),
              oidc4vc: OIDC4VC(),
              advanceSettingsCubit: context.read<AdvanceSettingsCubit>(),
              jwtDecode: JWTDecode(),
              profileCubit: context.read<ProfileCubit>(),
              walletCubit: context.read<WalletCubit>(),
              activityLogManager: ActivityLogManager(secureStorageProvider),
            ),
          ),
          BlocProvider<ManageNetworkCubit>(
            create: (context) => ManageNetworkCubit(
              secureStorageProvider: secureStorageProvider,
              walletCubit: context.read<WalletCubit>(),
              profileCubit: context.read<ProfileCubit>(),
            ),
          ),
          BlocProvider<ScanCubit>(
            create: (context) => ScanCubit(
              client: DioClient(
                baseUrl: Urls.checkIssuerTalaoUrl,
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
              credentialsCubit: context.read<CredentialsCubit>(),
              didKitProvider: DIDKitProvider(),
              secureStorageProvider: secureStorageProvider,
              profileCubit: context.read<ProfileCubit>(),
              walletCubit: context.read<WalletCubit>(),
              oidc4vc: OIDC4VC(),
              jwtDecode: JWTDecode(),
              activityLogManager: ActivityLogManager(secureStorageProvider),
            ),
          ),
          BlocProvider<AltmeChatSupportCubit>(
            lazy: false,
            create: (context) => AltmeChatSupportCubit(
              secureStorageProvider: secureStorageProvider,
              matrixChat: MatrixChatImpl(),
              profileCubit: context.read<ProfileCubit>(),
              roomIdStoredKey: SecureStorageKeys.chatSupportRoomId,
            ),
          ),
          BlocProvider<MatrixNotificationCubit>(
            lazy: false,
            create: (context) => MatrixNotificationCubit(
              secureStorageProvider: secureStorageProvider,
              matrixChat: MatrixChatImpl(),
              profileCubit: context.read<ProfileCubit>(),
              roomIdStoredKey: SecureStorageKeys.notificationSupportRoomId,
            ),
          ),
          BlocProvider<EnterpriseCubit>(
            create: (context) => EnterpriseCubit(
              client: DioClient(
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
              profileCubit: context.read<ProfileCubit>(),
              credentialsCubit: context.read<CredentialsCubit>(),
              matrixNotificationCubit: context.read<MatrixNotificationCubit>(),
              altmeChatSupportCubit: context.read<AltmeChatSupportCubit>(),
            ),
          ),
          BlocProvider<QRCodeScanCubit>(
            create: (context) => QRCodeScanCubit(
              client: DioClient(
                baseUrl: Urls.checkIssuerTalaoUrl,
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
              scanCubit: context.read<ScanCubit>(),
              queryByExampleCubit: context.read<QueryByExampleCubit>(),
              deepLinkCubit: context.read<DeepLinkCubit>(),
              jwtDecode: JWTDecode(),
              profileCubit: context.read<ProfileCubit>(),
              credentialsCubit: context.read<CredentialsCubit>(),
              beacon: Beacon(),
              walletConnectCubit: context.read<WalletConnectCubit>(),
              secureStorageProvider: secureStorageProvider,
              didKitProvider: DIDKitProvider(),
              oidc4vc: OIDC4VC(),
              walletCubit: context.read<WalletCubit>(),
              enterpriseCubit: context.read<EnterpriseCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => AllTokensCubit(
              secureStorageProvider: secureStorageProvider,
              client: DioClient(
                baseUrl: Urls.coinGeckoBase,
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
            ),
          ),
          BlocProvider(
            create: (_) => MnemonicNeedVerificationCubit(),
          ),
          BlocProvider<TokensCubit>(
            create: (context) => TokensCubit(
              allTokensCubit: context.read<AllTokensCubit>(),
              networkCubit: context.read<ManageNetworkCubit>(),
              mnemonicNeedVerificationCubit:
                  context.read<MnemonicNeedVerificationCubit>(),
              secureStorageProvider: secureStorageProvider,
              client: DioClient(
                baseUrl:
                    context.read<ManageNetworkCubit>().state.network.apiUrl,
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
              walletCubit: context.read<WalletCubit>(),
            ),
          ),
          BlocProvider<NftCubit>(
            create: (context) => NftCubit(
              client: DioClient(
                baseUrl:
                    context.read<ManageNetworkCubit>().state.network.apiUrl,
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
              walletCubit: context.read<WalletCubit>(),
              manageNetworkCubit: context.read<ManageNetworkCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => SplashCubit(
              secureStorageProvider: secureStorageProvider,
              homeCubit: context.read<HomeCubit>(),
              client: DioClient(
                baseUrl: Urls.checkIssuerTalaoUrl,
                secureStorageProvider: secureStorageProvider,
                dio: Dio(),
              ),
              altmeChatSupportCubit: context.read<AltmeChatSupportCubit>(),
              matrixNotificationCubit: context.read<MatrixNotificationCubit>(),
              qrCodeScanCubit: context.read<QRCodeScanCubit>(),
              credentialsCubit: context.read<CredentialsCubit>(),
              walletCubit: context.read<WalletCubit>(),
              profileCubit: context.read<ProfileCubit>(),
              walletConnectCubit: context.read<WalletConnectCubit>(),
            ),
          ),
          BlocProvider(create: (context) => HomeTabbarCubit()),
        ],
        child: const MaterialAppDefinition(),
      ),
    );
  }
}

class MaterialAppDefinition extends StatelessWidget {
  const MaterialAppDefinition({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        if (state.locale == const Locale('en')) {
          context.read<LangCubit>().checkLocale();
        }

        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (themeContext, themeState) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              builder: (profileContext, profileState) {
                return MaterialApp(
                  locale: state.locale,
                  title: 'AltMe',
                  theme: AppTheme.seedThemeData(
                    Brightness.light,
                    profileState
                        .model.profileSetting.generalOptions.primaryColor,
                  ),
                  darkTheme: AppTheme.seedThemeData(
                    Brightness.dark,
                    profileState
                        .model.profileSetting.generalOptions.primaryColor,
                  ),
                  navigatorObservers: [MyRouteObserver(context)],
                  themeMode: themeState.themeMode,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: const SplashPage(),
                  onUnknownRoute: (settings) => MaterialPageRoute(
                    builder: (context) => const PageNotFound(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
