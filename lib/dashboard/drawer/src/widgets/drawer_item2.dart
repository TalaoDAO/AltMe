import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class DrawerItem2 extends StatelessWidget {
  const DrawerItem2({
    super.key,
    required this.title,
    this.subtitle,
    this.isDisabled = false,
    this.onTap,
    this.trailing,
    this.padding = const EdgeInsets.all(Sizes.spaceNormal),
  });

  final bool isDisabled;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return TransparentInkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: const EdgeInsets.all(Sizes.spaceXSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              Sizes.normalRadius,
            ),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: isDisabled
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6)
                                : null,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        subtitle!,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: isDisabled
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6)
                                      : null,
                                ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.chevron_right,
                  size: 26,
                  color: isDisabled
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
