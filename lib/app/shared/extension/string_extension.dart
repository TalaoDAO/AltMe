import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String get formatNumber {
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

  String get char2Bytes {
    final List<int> encode = utf8.encode(this);
    final String bytes = hex.encode(encode);
    return bytes;
  }

  bool get isEVM {
    if (this == 'ETH' || this == 'MATIC' || this == 'FTM' || this == 'BNB') {
      return true;
    }
    return false;
  }

  String decimalNumber(int n) {
    int number = 1;
    for (int i = 0; i < n; i++) {
      if (i > toString().split('.').toList().last.length) {
        break;
      }
      number *= 10;
    }

    final twoDecimalNumber =
        (Decimal.parse(this) * Decimal.parse(number.toString())).floor() /
            Decimal.parse(number.toString());
    return twoDecimalNumber.toDecimal().toString();
  }
}
