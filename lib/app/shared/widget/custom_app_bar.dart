import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({
    super.key,
    this.title,
    this.titleMargin = EdgeInsets.zero,
    this.leading,
    this.trailing,
    this.titleAlignment = Alignment.bottomCenter,
    this.appBarHeight = Sizes.appBarHeight,
  }) : super(
          child: Container(),
          preferredSize: Size.fromHeight(appBarHeight),
        );

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets titleMargin;
  final Alignment titleAlignment;
  final double appBarHeight;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (leading != null) leading!,
                    if (trailing != null) trailing!,
                  ],
                ),
                Container(
                  alignment: titleAlignment,
                  padding: titleMargin.copyWith(
                    top: titleMargin.top + 10,
                    left: titleMargin.left + 38,
                    right: titleMargin.right + 38,
                    bottom: titleMargin.bottom + 6,
                  ),
                  child: Text(
                    title ?? '',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  // @override
  // Size get preferredSize => const Size(300, 70);
}
