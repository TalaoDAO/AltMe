import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final log = getLogger('WertInitState');

    // #docregion platform_features
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
      ..loadRequest(
        Uri.parse(
          'https://sandbox.wert.io/01GMWDYDRESASBVVV7SB6FHYZE/redirect?theme=dark&lang=en',
        ),
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
    return BasePage(
      scrollView: false,
      body: WebViewWidget(controller: _controller),
      padding: EdgeInsets.zero,
    );
  }
}
