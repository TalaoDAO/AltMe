import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCupertinoTextSelectionControls extends CupertinoTextSelectionControls {
  AppCupertinoTextSelectionControls({
    required this.onPaste,
  });
  ValueChanged<TextSelectionDelegate> onPaste;
  @override
  Future<void> handlePaste(final TextSelectionDelegate delegate) {
    onPaste(delegate);
    return super.handlePaste(delegate);
  }
}

class AppMaterialTextSelectionControls extends MaterialTextSelectionControls {
  AppMaterialTextSelectionControls({
    required this.onPaste,
  });
  ValueChanged<TextSelectionDelegate> onPaste;
  @override
  Future<void> handlePaste(final TextSelectionDelegate delegate) {
    onPaste(delegate);
    return super.handlePaste(delegate);
  }
}
