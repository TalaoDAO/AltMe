import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AdvanceSettingsRadioItem extends StatelessWidget {
  const AdvanceSettingsRadioItem({
    super.key,
    required this.title,
    required this.isSelected,
    this.onPressed,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: Checkbox(
        value: isSelected,
        fillColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.inversePrimary,
        ),
        checkColor: Theme.of(context).colorScheme.primary,
        onChanged: (_) => onPressed?.call(),
        shape: const CircleBorder(),
      ),
      title: MyText(
        title,
        maxLines: 1,
        minFontSize: 12,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}
