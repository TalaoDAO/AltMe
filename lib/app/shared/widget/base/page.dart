import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:secure_application/secure_application.dart';

class BasePage extends StatefulWidget {
  const BasePage({
    Key? key,
    this.scaffoldKey,
    this.backgroundColor,
    this.title,
    this.titleMargin = EdgeInsets.zero,
    this.titleTag,
    this.titleLeading,
    this.titleTrailing,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 20,
    ),
    this.scrollView = true,
    this.navigation,
    this.drawer,
    this.extendBelow,
    required this.body,
    this.useSafeArea = true,
    this.titleAlignment = Alignment.bottomCenter,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.secureScreen = false,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? title;
  final EdgeInsets titleMargin;
  final Widget body;
  final bool scrollView;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final String? titleTag;
  final Widget? titleLeading;
  final Widget? titleTrailing;
  final Widget? navigation;
  final Widget? drawer;
  final bool? extendBelow;
  final bool useSafeArea;
  final Alignment titleAlignment;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool secureScreen;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> with WidgetsBindingObserver {
  final SecureApplicationController secureApplicationController =
      SecureApplicationController(
    SecureApplicationState(secured: true),
  );

  final noScreenShot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.secureScreen) {
      noScreenShot.screenshotOff();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (widget.secureScreen) {
          noScreenShot.screenshotOff();
        } else {
          noScreenShot.screenshotOn();
        }
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (widget.secureScreen) {
          noScreenShot.screenshotOff();
          secureApplicationController.lock();
        }
        break;

      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.secureScreen) {
      noScreenShot.screenshotOn();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.secureScreen
        ? SecureApplication(
            nativeRemoveDelay: 800,
            autoUnlockNative: true,
            secureApplicationController: secureApplicationController,
            onNeedUnlock: (secureApplicationController) async {
              /// need unlock maybe use biometric to confirm and then
              /// sercure.unlock() or you can use the lockedBuilder

              secureApplicationController!.authSuccess(unlock: true);
              return SecureApplicationAuthenticationStatus.SUCCESS;
              //return null;
            },
            child: Builder(
              builder: (context) {
                return SecureGate(
                  blurr: 100,
                  opacity: 0.1,
                  lockedBuilder: (context, secureNotifier) => Container(),
                  child: Scaffold(
                    key: widget.scaffoldKey,
                    floatingActionButton: widget.floatingActionButton,
                    floatingActionButtonLocation:
                        widget.floatingActionButtonLocation,
                    extendBody: widget.extendBelow ?? false,
                    backgroundColor: widget.backgroundColor ??
                        Theme.of(context).colorScheme.background,
                    appBar: (widget.title == null &&
                            widget.titleLeading == null &&
                            widget.titleTrailing == null)
                        ? null
                        : CustomAppBar(
                            title: widget.title,
                            titleMargin: widget.titleMargin,
                            leading: widget.titleLeading,
                            titleAlignment: widget.titleAlignment,
                            trailing: widget.titleTrailing,
                          ),
                    bottomNavigationBar: widget.navigation != null
                        ? (widget.useSafeArea
                            ? SafeArea(child: widget.navigation!)
                            : widget.navigation)
                        : null,
                    drawer: widget.drawer,
                    body: widget.scrollView
                        ? SingleChildScrollView(
                            padding: widget.padding,
                            physics: const BouncingScrollPhysics(),
                            child: widget.useSafeArea
                                ? SafeArea(child: widget.body)
                                : widget.body,
                          )
                        : Padding(
                            padding: widget.padding,
                            child: widget.useSafeArea
                                ? SafeArea(child: widget.body)
                                : widget.body,
                          ),
                  ),
                );
              },
            ),
          )
        : Scaffold(
            key: widget.scaffoldKey,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            extendBody: widget.extendBelow ?? false,
            backgroundColor: widget.backgroundColor ??
                Theme.of(context).colorScheme.background,
            appBar: (widget.title == null &&
                    widget.titleLeading == null &&
                    widget.titleTrailing == null)
                ? null
                : CustomAppBar(
                    title: widget.title,
                    titleMargin: widget.titleMargin,
                    leading: widget.titleLeading,
                    titleAlignment: widget.titleAlignment,
                    trailing: widget.titleTrailing,
                  ),
            bottomNavigationBar: widget.navigation != null
                ? (widget.useSafeArea
                    ? SafeArea(child: widget.navigation!)
                    : widget.navigation)
                : null,
            drawer: widget.drawer,
            body: widget.scrollView
                ? SingleChildScrollView(
                    padding: widget.padding,
                    physics: const BouncingScrollPhysics(),
                    child: widget.useSafeArea
                        ? SafeArea(child: widget.body)
                        : widget.body,
                  )
                : Padding(
                    padding: widget.padding,
                    child: widget.useSafeArea
                        ? SafeArea(child: widget.body)
                        : widget.body,
                  ),
          );
  }
}
