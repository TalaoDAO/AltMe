import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({
    Key? key,
    this.title,
    this.leading,
    this.trailing,
  }) : super(
          key: key,
          child: Container(),
          preferredSize: const Size.fromHeight(Sizes.appBarHeight),
        );

  final String? title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: true,
        leading: leading,
        actions: [if (trailing != null) trailing!],
        backgroundColor: Theme.of(context).colorScheme.background,
        title: MyText(
          title ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.appBar,
        ),
      );
}
