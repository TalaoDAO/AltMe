import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

typedef OnNavigationRequest = Future<NavigationDecision> Function(
  NavigationRequest request,
);

class MWebViewPage extends StatelessWidget {
  const MWebViewPage({
    super.key,
    required this.url,
    this.headers,
    this.body,
    this.onNavigationRequest,
  });

  final String url;
  final Map<String, String>? headers;
  final Uint8List? body;
  final OnNavigationRequest? onNavigationRequest;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MWebViewCubit(),
      child: MWebView(
        url: url,
        headers: headers,
        body: body,
        onNavigationRequest: onNavigationRequest,
      ),
    );
  }
}

class MWebView extends StatefulWidget {
  const MWebView({
    super.key,
    required this.url,
    this.headers,
    this.body,
    this.onNavigationRequest,
  });

  final String url;
  final Map<String, String>? headers;
  final Uint8List? body;
  final OnNavigationRequest? onNavigationRequest;

  @override
  _MWebViewState createState() => _MWebViewState();
}

class _MWebViewState extends State<MWebView>
    with AutomaticKeepAliveClientMixin<MWebView> {
  final log = getLogger('MWebView');
  late final WebViewController _webViewController;
  late final MWebViewCubit mWebViewCubit;

  WebViewController _getWebViewController() {
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
            Sentry.captureMessage('WebView is loading (progress : $progress%)');
            if (progress == 100) {
              mWebViewCubit.setLoading(isLoading: false);
            }
          },
          onPageStarted: (String url) {
            Sentry.captureMessage('Page started loading: $url');
            mWebViewCubit.setLoading(isLoading: true);
          },
          onPageFinished: (String url) {
            Sentry.captureMessage('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            mWebViewCubit.setLoading(isLoading: false);
            Sentry.captureMessage('''
                Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            Sentry.captureMessage('navigate - ${request.url}');
            if (widget.onNavigationRequest != null) {
              return widget.onNavigationRequest!.call(request);
            } else {
              return NavigationDecision.navigate;
            }
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
    return controller;
  }

  @override
  void initState() {
    mWebViewCubit = context.read<MWebViewCubit>();
    _webViewController = _getWebViewController();
    _webViewController.loadRequest(
      Uri.parse(widget.url),
      headers: widget.headers ?? {},
      body: widget.body,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MWebViewCubit, bool>(
      builder: (context, isLoading) {
        return IndexedStack(
          sizing: StackFit.expand,
          index: isLoading ? 0 : 1,
          children: [
            const Center(
              child: CircularProgressIndicator(),
            ),
            WebViewWidget(controller: _webViewController),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
