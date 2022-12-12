import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    Key? key,
    this.label,
    required this.controller,
    this.suffixIcon,
    this.type = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.error,
    this.prefixIcon,
    this.validator,
    this.focusNode,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    this.borderColor,
    this.fillColor,
    this.borderRadius = 50,
    this.height,
    this.maxLines = 1,
    this.hint,
    this.hintStyle,
  }) : super(key: key);

  final String? label;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextInputType type;
  final TextCapitalization textCapitalization;
  final String? error;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry contentPadding;
  final Color? borderColor;
  final Color? fillColor;
  final double borderRadius;
  final double? height;
  final int maxLines;
  final String? hint;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? Theme.of(context).colorScheme.tertiary;
    return SizedBox(
      height: height,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        cursorColor: Theme.of(context).colorScheme.primary,
        keyboardType: type,
        maxLines: maxLines,
        toolbarOptions: const ToolbarOptions(
          paste: true,
          cut: true,
          selectAll: true,
          copy: true,
        ),
        textCapitalization: textCapitalization,
        style: Theme.of(context).textTheme.normal,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: hintStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: border,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: border,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: border,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1.5,
            ),
          ),
          fillColor: fillColor ?? Theme.of(context).colorScheme.background,
          filled: true,
          errorText: error,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.normal,
          prefixIcon: prefixIcon,
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(minWidth: 60),
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
