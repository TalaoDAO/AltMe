import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class WertPage extends StatelessWidget {
  const WertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WertCubit(
        walletCubit: context.read<WalletCubit>(),
        credentialsRepository: CredentialsRepository(getSecureStorage),
      ),
      child: const WertView(),
    );
  }
}

class WertView extends StatefulWidget {
  const WertView({super.key});

  @override
  State<WertView> createState() => _WertViewState();
}

class _WertViewState extends State<WertView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final log = getLogger('WertInitState');

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log.i('WebView is loading (progress : $progress%)');
            if (progress == 100) {
              LoadingView().hide();
            }
          },
          onPageStarted: (String url) {
            log.i('Page started loading: $url');
            LoadingView().show(context: context);
          },
          onPageFinished: (String url) {
            log.i('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            LoadingView().hide();
            log.i('''
                Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            log.i('navigate - ${request.url}');
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   log.i('blocking navigation to ${request.url}');
            //   return NavigationDecision.prevent;
            // }
            // log.i('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<ManageNetworkCubit, ManageNetworkState>(
          listener: (context, state) async {
            await context.read<WertCubit>().getUrl();
          },
        ),
        BlocListener<WertCubit, String>(
          listener: (context, link) async {
            await _controller.loadRequest(Uri.parse(link));
          },
        ),
      ],
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return BasePage(
            scrollView: false,
            body:
                state.currentAccount!.blockchainType == BlockchainType.fantom ||
                        state.currentAccount!.blockchainType ==
                            BlockchainType.binance
                    ? Center(
                        child: Text(
                          state.currentAccount!.blockchainType ==
                                  BlockchainType.binance
                              ? l10n.thisFeatureIsNotSupportedYetForBinance
                              : l10n.thisFeatureIsNotSupportedYetForFantom,
                        ),
                      )
                    : WebViewWidget(controller: _controller),
            padding: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}
