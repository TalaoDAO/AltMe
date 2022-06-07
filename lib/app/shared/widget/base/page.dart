import 'package:altme/app/shared/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    Key? key,
    this.scaffoldKey,
    this.backgroundColor,
    this.title,
    this.titleTag,
    this.titleLeading,
    this.titleTrailing,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 20,
    ),
    this.scrollView = true,
    this.navigation,
    this.drawer,
    this.extendBelow,
    required this.body,
    this.useSafeArea = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? title;
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
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      extendBody: extendBelow ?? false,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.background,
      appBar: (title == null && titleLeading == null && titleTrailing == null)
          ? null
          : CustomAppBar(
              title: title,
              leading: titleLeading,
              trailing: titleTrailing,
            ),
      bottomNavigationBar: navigation,
      drawer: drawer,
      body: scrollView
          ? SingleChildScrollView(
              padding: padding,
              physics: const BouncingScrollPhysics(),
              child: useSafeArea ? SafeArea(child: body) : body,
            )
          : Padding(
              padding: padding,
              child: useSafeArea ? SafeArea(child: body) : body,
            ),
    );
  }
}
