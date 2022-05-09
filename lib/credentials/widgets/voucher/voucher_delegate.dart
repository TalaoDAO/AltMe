import 'package:flutter/material.dart';

class VoucherDelegate extends MultiChildLayoutDelegate {

  VoucherDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('voucherValue')) {
      layoutChild('voucherValue', BoxConstraints.loose(size));
      positionChild(
          'voucherValue', Offset(size.width * 0.27, size.height * 0.95));
    }
  }

  @override
  bool shouldRelayout(covariant VoucherDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
