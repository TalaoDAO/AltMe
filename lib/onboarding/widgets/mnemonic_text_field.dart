import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class MnemonicTextField extends StatelessWidget {
  const MnemonicTextField({
    super.key,
    required this.controller,
    this.type = TextInputType.text,
    this.validator,
    this.focusNode,
    this.fillColor,
    this.onChanged,
  });

  final TextEditingController controller;
  final TextInputType type;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Color? fillColor;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        textAlign: TextAlign.center,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        controller: controller,
        enableInteractiveSelection: true,
        textCapitalization: TextCapitalization.none,
        validator: validator,
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.passPhraseText,
        cursorColor: Theme.of(context).colorScheme.titleColor,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Sizes.spaceSmall,
            vertical: Sizes.spaceSmall + 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(128),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(128),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(128),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
