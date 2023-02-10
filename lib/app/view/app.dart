// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/did/did.dart';
import 'package:altme/flavor/cubit/flavor_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/route/route.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:key_generator/key_generator.dart';
import 'package:matrix/matrix.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

class App extends StatelessWidget {
  const App({super.key, this.flavorMode = FlavorMode.production});

  final FlavorMode flavorMode;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FlavorCubit>(
          create: (context) => FlavorCubit(flavorMode),
        ),
        BlocProvider<RouteCubit>(create: (context) => RouteCubit()),
        BlocProvider<BeaconCubit>(
          create: (context) => BeaconCubit(beacon: Beacon()),
        ),
        BlocProvider<WalletConnectCubit>(
          create: (context) => WalletConnectCubit(
            connectedDappRepository:
                ConnectedDappRepository(secure_storage.getSecureStorage),
          ),
        ),
        BlocProvider<DeepLinkCubit>(create: (context) => DeepLinkCubit()),
        BlocProvider<QueryByExampleCubit>(
          create: (context) => QueryByExampleCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            secureStorageProvider: secure_storage.getSecureStorage,
          ),
        ),
        BlocProvider<AdvanceSettingsCubit>(
          create: (context) {
            return AdvanceSettingsCubit(
              secureStorageProvider: getSecureStorage,
            );
          },
        ),
        BlocProvider<ManageNetworkCubit>(
          create: (context) => ManageNetworkCubit(
            secureStorageProvider: secure_storage.getSecureStorage,
          ),
        ),
        BlocProvider<CredentialListCubit>(
          create: (context) => CredentialListCubit(),
        ),
        BlocProvider<DIDCubit>(
          create: (context) => DIDCubit(
            secureStorageProvider: secure_storage.getSecureStorage,
            didKitProvider: DIDKitProvider(),
          ),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            client: DioClient(Urls.issuerBaseUrl, Dio()),
            secureStorageProvider: secure_storage.getSecureStorage,
            didCubit: context.read<DIDCubit>(),
          ),
        ),
        BlocProvider<WalletCubit>(
          lazy: false,
          create: (context) => WalletCubit(
            credentialsRepository:
                CredentialsRepository(secure_storage.getSecureStorage),
            connectedDappRepository:
                ConnectedDappRepository(secure_storage.getSecureStorage),
            secureStorageProvider: secure_storage.getSecureStorage,
            profileCubit: context.read<ProfileCubit>(),
            homeCubit: context.read<HomeCubit>(),
            credentialListCubit: context.read<CredentialListCubit>(),
            keyGenerator: KeyGenerator(),
            didKitProvider: DIDKitProvider(),
            didCubit: context.read<DIDCubit>(),
            advanceSettingsCubit: context.read<AdvanceSettingsCubit>(),
          ),
        ),
        BlocProvider<ScanCubit>(
          create: (context) => ScanCubit(
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
            walletCubit: context.read<WalletCubit>(),
            didKitProvider: DIDKitProvider(),
            secureStorageProvider: secure_storage.getSecureStorage,
            ebsi: Ebsi(Dio()),
          ),
        ),
        BlocProvider<QRCodeScanCubit>(
          create: (context) => QRCodeScanCubit(
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
            requestClient: DioClient('', Dio()),
            scanCubit: context.read<ScanCubit>(),
            queryByExampleCubit: context.read<QueryByExampleCubit>(),
            deepLinkCubit: context.read<DeepLinkCubit>(),
            jwtDecode: JWTDecode(),
            profileCubit: context.read<ProfileCubit>(),
            walletCubit: context.read<WalletCubit>(),
            beacon: Beacon(),
            walletConnectCubit: context.read<WalletConnectCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => SplashCubit(
            secureStorageProvider: secure_storage.getSecureStorage,
            didCubit: context.read<DIDCubit>(),
            homeCubit: context.read<HomeCubit>(),
            walletCubit: context.read<WalletCubit>(),
            client: DioClient(Urls.checkIssuerTalaoUrl, Dio()),
          ),
        ),
        BlocProvider(
          create: (context) => AllTokensCubit(
            secureStorageProvider: secure_storage.getSecureStorage,
            client: DioClient(
              Urls.tezToolBase,
              Dio(),
            ),
          ),
        ),
        BlocProvider<TokensCubit>(
          create: (context) => TokensCubit(
            allTokensCubit: context.read<AllTokensCubit>(),
            networkCubit: context.read<ManageNetworkCubit>(),
            secureStorageProvider: secure_storage.getSecureStorage,
            client: DioClient(
              context.read<ManageNetworkCubit>().state.network.apiUrl,
              Dio(),
            ),
            walletCubit: context.read<WalletCubit>(),
          ),
        ),
        BlocProvider<NftCubit>(
          create: (context) => NftCubit(
            client: DioClient(
              context.read<ManageNetworkCubit>().state.network.apiUrl,
              Dio(),
            ),
            walletCubit: context.read<WalletCubit>(),
            manageNetworkCubit: context.read<ManageNetworkCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => LiveChatCubit(
            dioClient: DioClient('', Dio()),
            didCubit: context.read<DIDCubit>(),
            secureStorageProvider: getSecureStorage,
            client: Client(
              'AltMeUser',
            ),
          ),
        ),
      ],
      child: const MaterialAppDefinition(),
    );
  }
}

class MaterialAppDefinition extends StatelessWidget {
  const MaterialAppDefinition({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isStaging =
        context.read<FlavorCubit>().flavorMode == FlavorMode.staging;
    return BlocProvider(
      create: (context) => LangCubit(),
      child: BlocBuilder<LangCubit, Locale>(
        builder: (context, lang) {
          //context.read<LangCubit>().fetchLocale();
          return MaterialApp(
            useInheritedMediaQuery: true,
            builder: isStaging ? DevicePreview.appBuilder : null,
            locale: isStaging ? DevicePreview.locale(context) : lang,
            title: 'Talao Wallet',
            darkTheme: AppTheme.darkThemeData,
            navigatorObservers: [MyRouteObserver(context)],
            themeMode: ThemeMode.dark,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
