import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class ProtectWidget extends StatelessWidget {
  const ProtectWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String image;
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
              : Theme.of(context).colorScheme.surfaceBright,
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
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image.asset(
                  image,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleMedium,
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
