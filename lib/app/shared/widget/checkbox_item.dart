import 'package:flutter/material.dart';

class CheckboxItem extends StatelessWidget {
  const CheckboxItem({
    super.key,
    this.value = false,
    this.textStyle,
    required this.text,
    required this.onChange,
  });

  final String text;
  final dynamic Function(bool) onChange;
  final bool value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange.call(!value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            fillColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            onChanged: (newValue) => onChange.call(newValue ?? value),
          ),
          Text(
            text,
            style: textStyle ?? Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
