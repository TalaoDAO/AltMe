import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef KeyboardTapCallback = dynamic Function(String text);

@immutable
class KeyboardUIConfig {
  const KeyboardUIConfig({
    this.digitBorderWidth = 3.5,
    this.spacing = 4,
    this.digitShape = BoxShape.circle,
    this.keyboardRowMargin = const EdgeInsets.only(top: 15, left: 4, right: 4),
    this.digitInnerMargin = const EdgeInsets.all(20),
    this.keyboardSize,
    this.digitTextStyle,
  });

  //Digits have a round thin borders, [digitBorderWidth] define their thickness
  final double digitBorderWidth;
  final double spacing;
  final BoxShape digitShape;
  final EdgeInsetsGeometry keyboardRowMargin;
  final EdgeInsetsGeometry digitInnerMargin;
  final TextStyle? digitTextStyle;

  //Size for the keyboard can be define and provided from the app.
  //If it will not be provided the size will be adjusted to a screen size.
  final Size? keyboardSize;
}

class NumericKeyboard extends StatelessWidget {
  NumericKeyboard({
    super.key,
    required this.keyboardUIConfig,
    required this.onKeyboardTap,
    this.leadingButton,
    this.trailingButton,
    required this.allowAction,
  });

  final KeyboardUIConfig keyboardUIConfig;
  final KeyboardTapCallback onKeyboardTap;
  final _focusNode = FocusNode();
  static String deleteButton = 'keyboard_delete_button';

  //should have a proper order [1...9, 0]
  final Widget? leadingButton;
  final Widget? trailingButton;
  final bool allowAction;

  @override
  Widget build(BuildContext context) {
    List<String> keyboardItems = List.filled(10, '0');
    keyboardItems = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = screenSize.height > screenSize.width
        ? screenSize.height / 2
        : screenSize.height - 80;
    final keyboardWidth = keyboardHeight * 3 / 4;
    final keyboardSize = keyboardUIConfig.keyboardSize != null
        ? keyboardUIConfig.keyboardSize!
        : Size(keyboardWidth, keyboardHeight);

    return Container(
      width: keyboardSize.width,
      height: keyboardSize.height,
      margin: const EdgeInsets.only(top: 16),
      alignment: Alignment.center,
      child: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyUpEvent) {
            if (keyboardItems.contains(event.data.keyLabel)) {
              onKeyboardTap(event.logicalKey.keyLabel);
              return;
            }
            if (event.logicalKey.keyLabel == 'Backspace' ||
                event.logicalKey.keyLabel == 'Delete') {
              onKeyboardTap(NumericKeyboard.deleteButton);
              return;
            }
          }
        },
        child: AlignedGrid(
          keyboardSize: keyboardSize,
          spacing: keyboardUIConfig.spacing,
          children: buildButtons(context, keyboardItems),
        ),
      ),
    );
  }

  List<Widget> buildButtons(BuildContext context, List<String> keyboardItems) {
    final List<Widget> allKeyboardButtons =
        List.generate(keyboardItems.length, (index) {
      return KeyboardButton(
        digitBorderWidth: keyboardUIConfig.digitBorderWidth,
        digitShape: keyboardUIConfig.digitShape,
        semanticsLabel: keyboardItems[index],
        onTap: onKeyboardTap,
        label: keyboardItems[index],
        digitTextStyle: keyboardUIConfig.digitTextStyle,
        allowAction: allowAction,
      );
    });

    if (leadingButton != null) {
      allKeyboardButtons.insert(keyboardItems.length - 1, leadingButton!);
      if (trailingButton == null) {
        allKeyboardButtons.insert(keyboardItems.length + 1, const Center());
      }
    }

    if (trailingButton != null) {
      if (leadingButton == null) {
        allKeyboardButtons.insert(keyboardItems.length - 1, const Center());
      }
      allKeyboardButtons.insert(keyboardItems.length + 1, trailingButton!);
    }

    return allKeyboardButtons;
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    required this.semanticsLabel,
    this.label,
    this.icon,
    this.onTap,
    this.onLongPress,
    this.digitShape = BoxShape.circle,
    this.digitBorderWidth = 3.4,
    this.digitTextStyle,
    required this.allowAction,
  });

  final BoxShape digitShape;
  final double digitBorderWidth;
  final String? label;
  final Widget? icon;
  final dynamic Function(String)? onTap;
  final dynamic Function(String)? onLongPress;
  final String semanticsLabel;
  final TextStyle? digitTextStyle;
  final bool allowAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: digitShape == BoxShape.circle
          ? ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: allowAction
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
                  splashColor: allowAction
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
                  onLongPress: () {
                    if (!allowAction) return;
                    onLongPress?.call(semanticsLabel);
                  },
                  onTap: () {
                    if (!allowAction) return;
                    onTap?.call(semanticsLabel);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: digitShape,
                      color: Colors.transparent,
                      border: digitBorderWidth > 0.0
                          ? Border.all(
                              color: allowAction
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.1),
                              width: digitBorderWidth,
                            )
                          : null,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: label != null
                          ? Text(
                              label!,
                              style: digitTextStyle != null
                                  ? allowAction
                                      ? digitTextStyle
                                      : digitTextStyle!.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.1),
                                        )
                                  : allowAction
                                      ? Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                      : Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.1),
                                          ),
                              semanticsLabel: semanticsLabel,
                            )
                          : icon,
                    ),
                  ),
                ),
              ),
            )
          : ClipRect(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    onTap?.call(semanticsLabel);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: digitShape,
                      color: Colors.transparent,
                      border: digitBorderWidth > 0.0
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: digitBorderWidth,
                            )
                          : null,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: label != null
                          ? Text(
                              label!,
                              style: digitTextStyle ??
                                  Theme.of(context).textTheme.headlineMedium,
                              semanticsLabel: semanticsLabel,
                            )
                          : icon,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class AlignedGrid extends StatelessWidget {
  const AlignedGrid({
    super.key,
    required this.children,
    required this.keyboardSize,
    this.spacing = 4,
    this.runSpacing = 4,
  });

  final double runSpacing;
  final double spacing;
  static const columns = 3;
  final List<Widget> children;
  final Size keyboardSize;

  @override
  Widget build(BuildContext context) {
    const heightAdjustment = 30;
    final itemWidth =
        (keyboardSize.width - (spacing * (columns - 1))) / columns;
    final rows = children.length / columns;
    final itemHeight =
        (keyboardSize.height - (runSpacing * (rows - 1)) - heightAdjustment) /
            rows;
    final itemSize = min(itemHeight, itemWidth);
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: children
          .map(
            (item) => SizedBox(
              width: itemSize,
              height: itemSize,
              child: item,
            ),
          )
          .toList(growable: false),
    );
  }
}
