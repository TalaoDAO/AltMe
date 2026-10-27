import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCupertinoTextSelectionControls extends CupertinoTextSelectionControls {
  AppCupertinoTextSelectionControls({required this.onPaste});
  ValueChanged<TextSelectionDelegate> onPaste;

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) {
    onPaste(delegate);
    final pasteFuture = super.handlePaste(delegate);
    return pasteFuture;
  }
}

class AppMaterialTextSelectionControls extends MaterialTextSelectionControls {
  AppMaterialTextSelectionControls({required this.onPaste});
  ValueChanged<TextSelectionDelegate> onPaste;
  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) {
    onPaste(delegate);
    final pasteFuture = super.handlePaste(delegate);
    return pasteFuture;
  }
}
