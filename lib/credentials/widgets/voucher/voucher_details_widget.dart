import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoucherDetailsWidget extends StatelessWidget {
  const VoucherDetailsWidget({Key? key, required this.model}) : super(key: key);
  final VoucherModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 508.67 / 319.67,
          child: SizedBox(
            height: 319.67,
            width: 508.67,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/image/voucher.png',
                      ))),
              child: AspectRatio(
                /// random size, copy from professional student card
                aspectRatio: 508.67 / 319.67,
                child: SizedBox(
                  height: 319.67,
                  width: 508.67,
                  child: CustomMultiChildLayout(
                    delegate: VoucherDelegate(position: Offset.zero),
                    children: [
                      LayoutId(
                          id: 'voucherValue',
                          child: Transform.rotate(
                            angle: 0.53,
                            child: Row(
                              children: [
                                TextWithVoucherStyle(
                                  value: NumberFormat.currency(
                                          name: model.offer.currency,
                                          locale: Intl.getCurrentLocale())
                                      .format(
                                    double.parse(model.offer.value),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
