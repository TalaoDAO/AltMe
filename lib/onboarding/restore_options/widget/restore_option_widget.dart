import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class RestoreOptionWidget extends StatelessWidget {
  const RestoreOptionWidget({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TransparentInkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceNormal,
          vertical: Sizes.spaceSmall,
        ),
        margin: const EdgeInsets.all(Sizes.spaceXSmall),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: isSelected
                          ? Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                          : Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
