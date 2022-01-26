import 'package:flutter/material.dart';
import 'package:ssi_crypto_wallet/shared/widget/tooltip_text.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({
    Key? key,
    this.tag,
    required this.title,
    this.leading,
    this.trailing,
  }) : super(
          key: key,
          child: Container(),
          preferredSize: const Size.fromHeight(80),
        );

  final String? tag;
  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).colorScheme.surface,
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 16,
              left: 64,
              right: 64,
            ),
            child: TooltipText(
              tag: tag,
              text: title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Material(
            color: Colors.transparent,
            type: MaterialType.transparency,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 8,
                left: 8,
                right: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  leading ?? const SizedBox(width: 16, height: 16),
                  trailing ?? const SizedBox(width: 16, height: 16),
                ],
              ),
            ),
          ),
        ],
      );
}
