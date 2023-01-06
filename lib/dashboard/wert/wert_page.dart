import 'dart:async';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class WertPage extends StatefulWidget {
  const WertPage({super.key});

  @override
  State<WertPage> createState() => _WertPageState();
}

class _WertPageState extends State<WertPage> {
  late WebViewController _controller;

  Future<void> onNetworkChange() async {
    final String link = getUrl();
    await _controller.loadRequest(Uri.parse(link));
  }

  String getUrl() {
    final walletCubit = context.read<WalletCubit>();

    String link =
        '''https://sandbox.wert.io/01GMWDYDRESASBVVV7SB6FHYZE/redirect?theme=dark&lang=en''';

    final symbol = walletCubit.state.currentAccount.blockchainType.symbol;
    final address = walletCubit.state.currentAccount.walletAddress;

    link = '$link&commodity=$symbol';
    link = '$link&address=$address';

    //input phone
    //link = '$link&phone=$phone';

    //input email
    //link = '$link&email=$email';

    return link;
  }

  @override
  void initState() {
    super.initState();
    final log = getLogger('WertInitState');

    final String link = getUrl();

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
    // #enddocregion platform_features

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
      )
      ..loadRequest(Uri.parse(link));

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
    return BlocListener<ManageNetworkCubit, ManageNetworkState>(
      listener: (context, state) {
        onNetworkChange();
      },
      child: BasePage(
        scrollView: false,
        body: WebViewWidget(controller: _controller!),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
