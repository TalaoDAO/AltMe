import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({
    Key? key,
    this.title,
    this.titleMargin = EdgeInsets.zero,
    this.leading,
    this.trailing,
    this.titleAlignment = Alignment.bottomCenter,
  }) : super(
          key: key,
          child: Container(),
          preferredSize: const Size.fromHeight(Sizes.appBarHeight),
        );

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets titleMargin;
  final Alignment titleAlignment;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  style: Theme.of(context).textTheme.appBar,
                ),
              ),
            ],
          ),
        ),
      );

  // @override
  // Size get preferredSize => const Size(300, 70);
}
