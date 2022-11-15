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
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    leading ?? const SizedBox(width: 16, height: 16),
                    trailing ?? const SizedBox(width: 16, height: 16),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: MyText(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.appBar,
                ),
              ),
            ),
          ],
        ),
      );

  // @override
  // Size get preferredSize => const Size(300, 70);
}
