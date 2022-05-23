import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    Key? key,
    this.label,
    required this.controller,
    this.icon = Icons.edit,
    this.type = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.error,
    this.prefixIcon,
    this.prefixConstraint,
    this.validator,
  }) : super(key: key);

  final String? label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType type;
  final TextCapitalization textCapitalization;
  final String? error;
  final Widget? prefixIcon;
  final BoxConstraints? prefixConstraint;
  final String? Function(String?)? validator;

  static const double borderRadius = 50;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.secondaryContainer,
      keyboardType: type,
      maxLines: 1,
      textCapitalization: textCapitalization,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 17),
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.textFieldBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.textFieldBorder,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.textFieldBorder,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.textFieldErrorBorder,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.textFieldErrorBorder,
            width: 1.5,
          ),
        ),
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        hoverColor: Theme.of(context).colorScheme.primaryContainer,
        focusColor: Theme.of(context).colorScheme.primaryContainer,
        errorText: error,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyText1,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixConstraint,
        suffixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}
