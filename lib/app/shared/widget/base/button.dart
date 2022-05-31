import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    Key? key,
    required this.child,
    required this.context,
    this.onPressed,
    this.gradient,
    this.textColor,
    this.borderColor,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  const BaseButton.white({
    Key? key,
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    Color? borderColor,
    EdgeInsets? margin,
  }) : this(
          key: key,
          child: child,
          context: context,
          onPressed: onPressed,
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          borderColor: borderColor,
          margin: margin ?? EdgeInsets.zero,
        );

  BaseButton.primary({
    Key? key,
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    Gradient? gradient,
    Color? borderColor,
    Color? textColor,
    EdgeInsets? margin,
  }) : this(
          key: key,
          child: child,
          context: context,
          onPressed: onPressed,
          gradient: gradient ??
              LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer
                ],
              ),
          textColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
          borderColor: borderColor,
          margin: margin ?? EdgeInsets.zero,
        );

  BaseButton.transparent({
    Key? key,
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    Color? borderColor,
    Color? textColor,
    EdgeInsets? margin,
  }) : this(
          key: key,
          child: child,
          context: context,
          onPressed: onPressed,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.transparent,
              Theme.of(context).colorScheme.transparent
            ],
          ),
          textColor:
              textColor ?? Theme.of(context).colorScheme.secondaryContainer,
          borderColor:
              borderColor ?? Theme.of(context).colorScheme.secondaryContainer,
          margin: margin ?? EdgeInsets.zero,
        );

  final Widget child;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? textColor;
  final Color? borderColor;
  final BuildContext context;
  final EdgeInsets margin;

  static BorderRadius buttonRadius = BorderRadius.circular(24);
  static EdgeInsets buttonPadding = const EdgeInsets.symmetric(vertical: 8);

  @override
  Widget build(BuildContext context) {
    final textColor = this.textColor ?? Colors.green;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: margin,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: buttonRadius,
            border: borderColor != null
                ? Border.all(width: 2, color: borderColor!)
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: buttonRadius,
            child: InkWell(
              onTap: onPressed,
              borderRadius: buttonRadius,
              child: Container(
                alignment: Alignment.center,
                padding: buttonPadding,
                child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .apply(color: textColor),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
