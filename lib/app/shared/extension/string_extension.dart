import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String formatNumber() {
    if (isEmpty || length < 3) return this;
    final formatter = NumberFormat('#,###');
    final value = this;
    final number = value.replaceAll(',', '');
    try {
      double.parse(number);
    } catch (e) {
      return this;
    }

    final splits = number.split('.');
    if (splits.length == 2) {
      final double intPart =
          double.parse(splits.first.isEmpty ? '0' : splits.first);
      return '''${formatter.format(intPart)}${splits.last.isEmpty ? '' : '.${splits.last}'}''';
    } else if (splits.length == 1) {
      final double intPart =
          double.parse(splits.first.isEmpty ? '0' : splits.first);
      return formatter.format(intPart);
    } else {
      return this;
    }
  }

  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  Characters get characters => Characters(this);
}
