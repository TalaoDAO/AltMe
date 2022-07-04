import 'package:flutter/material.dart';

typedef CloaseLoading = bool Function();
typedef UpdateLoading = bool Function(String text);

@immutable
class LoadingViewController {
  const LoadingViewController({
    required this.close,
    required this.update,
  });

  final CloaseLoading close;
  final UpdateLoading update;
}
