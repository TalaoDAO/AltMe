import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class CheckboxItem extends StatelessWidget {
  const CheckboxItem({
    Key? key,
    this.value = false,
    required this.text,
    required this.onChange,
  }) : super(key: key);

  final String text;
  final Function(bool) onChange;
  final bool value;

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
          const SizedBox(
            width: Sizes.space2XSmall,
          ),
          MyText(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
