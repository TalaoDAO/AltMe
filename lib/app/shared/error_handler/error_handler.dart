import 'package:flutter/material.dart';

class ErrorHandler implements Exception {
  String getErrorMessage(BuildContext context, ErrorHandler errorHandler) {
    return 'Unknown error';
  }
}
