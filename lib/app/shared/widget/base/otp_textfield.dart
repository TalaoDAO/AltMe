import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({
    super.key,
    required this.controllers,
    this.autoFocus = false,
    required this.index,
  });

  final List<TextEditingController> controllers;
  final bool autoFocus;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controllers[index],
        maxLength: 1,
        style: Theme.of(context).textTheme.labelLarge,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.lightPurple,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 1.5,
            ),
          ),
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length == 1) {
            /// some value added
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            if (index == 0) {
              controllers[index].clear();
            } else {
              controllers[index].clear();
              controllers[index - 1].clear();
              FocusScope.of(context).previousFocus();
            }
          }
        },
        onTap: () {
          // Move the cursor to the end of the text when TextField get focus
          controllers[index].selection = TextSelection.fromPosition(
            TextPosition(offset: controllers[index].text.length),
          );
        },
      ),
    );
  }
}
