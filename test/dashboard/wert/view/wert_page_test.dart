import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../../../helpers/helpers.dart';

// Fake WebView Platform following Flutter's official pattern
class FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return FakeWebViewController(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return FakeNavigationDelegate(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return FakeWebViewWidget(params);
  }

  @override
  PlatformWebViewCookieManager createPlatformCookieManager(
    PlatformWebViewCookieManagerCreationParams params,
  ) {
    return FakeCookieManager(params);
  }
}

// Fake Platform Classes following Flutter's official pattern
class FakeWebViewController extends PlatformWebViewController {
  FakeWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<String?> currentUrl() async => 'https://www.example.com';
}

class FakeWebViewWidget extends PlatformWebViewWidget {
  FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hello World',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'WebView Mock for Testing',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class FakeNavigationDelegate extends PlatformNavigationDelegate {
  FakeNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {}

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {}

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {}

  @override
  Future<void> setOnUrlChange(UrlChangeCallback onUrlChange) async {}

  @override
  Future<void> setOnHttpAuthRequest(
    HttpAuthRequestCallback handler,
  ) async {}

  @override
  Future<void> setOnHttpError(HttpResponseErrorCallback onHttpError) async {}
}

class FakeCookieManager extends PlatformWebViewCookieManager {
  FakeCookieManager(super.params) : super.implementation();
}

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

// Mock Cubits without state overrides
class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

class MockWertCubit extends MockCubit<String> implements WertCubit {}

class MockManageNetworkCubit extends MockCubit<ManageNetworkState>
    implements ManageNetworkCubit {}

void main() {
  group('WertView Tests', () {
    late MockWalletCubit mockWalletCubit;
    late MockWertCubit mockWertCubit;
    late MockManageNetworkCubit mockManageNetworkCubit;
    late MockSecureStorageProvider mockSecureStorageProvider;

    setUpAll(() {
      // Set up WebView platform mock
      WebViewPlatform.instance = FakeWebViewPlatform();
    });

    setUp(() {
      mockWalletCubit = MockWalletCubit();
      mockWertCubit = MockWertCubit();
      mockManageNetworkCubit = MockManageNetworkCubit();
      mockSecureStorageProvider = MockSecureStorageProvider();

      // Mock secure storage methods
      when(() => mockSecureStorageProvider.get(any()))
          .thenAnswer((_) async => '');
      when(() => mockSecureStorageProvider.set(any(), any()))
          .thenAnswer((_) async => {});
      when(() => mockSecureStorageProvider.delete(any()))
          .thenAnswer((_) async => {});
      when(() => mockSecureStorageProvider.deleteAll())
          .thenAnswer((_) async => {});
      when(() => mockSecureStorageProvider.getAllValues())
          .thenAnswer((_) async => <String, String>{});

      // Set default states
      when(() => mockWalletCubit.state).thenReturn(const WalletState());
      when(() => mockWertCubit.state).thenReturn('');
      when(() => mockManageNetworkCubit.state)
          .thenReturn(ManageNetworkState(network: TezosNetwork.mainNet()));
    });

    testWidgets('renders WertView when WalletCubit state is valid',
        (tester) async {
      // Arrange
      when(() => mockWalletCubit.state).thenReturn(
        WalletState(
          cryptoAccount: CryptoAccount(
            data: [
              CryptoAccountData(
                name: 'Test Account',
                secretKey: 'test_secret',
                blockchainType: BlockchainType.tezos,
                walletAddress: 'test_address',
              ),
            ],
          ),
        ),
      );

      when(() => mockWertCubit.state).thenReturn('https://test.example.com');

      // Act
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<WalletCubit>.value(value: mockWalletCubit),
            BlocProvider<WertCubit>.value(value: mockWertCubit),
            BlocProvider<ManageNetworkCubit>.value(
                value: mockManageNetworkCubit,),
          ],
          child: const WertView(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(WertView), findsOneWidget);
    });

    testWidgets('shows WebView mock when state is provided', (tester) async {
      // Arrange
      when(() => mockWalletCubit.state).thenReturn(
        WalletState(
          cryptoAccount: CryptoAccount(
            data: [
              CryptoAccountData(
                name: 'Test Account',
                secretKey: 'test_secret',
                blockchainType: BlockchainType.tezos,
                walletAddress: 'test_address',
              ),
            ],
          ),
        ),
      );

      when(() => mockWertCubit.state).thenReturn('https://test.example.com');

      // Act
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<WalletCubit>.value(value: mockWalletCubit),
            BlocProvider<WertCubit>.value(value: mockWertCubit),
            BlocProvider<ManageNetworkCubit>.value(
                value: mockManageNetworkCubit,),
          ],
          child: const WertView(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Look for our fake WebView content
      expect(find.text('Hello World'), findsOneWidget);
      expect(find.text('WebView Mock for Testing'), findsOneWidget);
    });

    testWidgets('handles empty WertCubit state', (tester) async {
      // Arrange
      when(() => mockWalletCubit.state).thenReturn(
        WalletState(
          cryptoAccount: CryptoAccount(
            data: [
              CryptoAccountData(
                name: 'Test Account',
                secretKey: 'test_secret',
                blockchainType: BlockchainType.tezos,
                walletAddress: 'test_address',
              ),
            ],
          ),
        ),
      );

      when(() => mockWertCubit.state).thenReturn('');

      // Act
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<WalletCubit>.value(value: mockWalletCubit),
            BlocProvider<WertCubit>.value(value: mockWertCubit),
            BlocProvider<ManageNetworkCubit>.value(
                value: mockManageNetworkCubit,),
          ],
          child: const WertView(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should handle empty state gracefully
      expect(find.byType(WertView), findsOneWidget);
    });
  });
}
