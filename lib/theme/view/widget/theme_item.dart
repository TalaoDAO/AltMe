import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeItem extends StatelessWidget {
  const ThemeItem({
    Key? key,
    this.isTrue = false,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final bool isTrue;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: Material(
        color: Theme.of(context).colorScheme.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.borderColor,
                  width: 0.4,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: isTrue
                        ? Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            )
                        : Theme.of(context).textTheme.bodyText1!,
                  ),
                ),
                const SizedBox(width: 16),
                if (isTrue)
                  Icon(
                    Icons.radio_button_checked,
                    size: 24,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
