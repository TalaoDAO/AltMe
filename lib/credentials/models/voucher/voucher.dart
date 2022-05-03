// ignore_for_file: unused_import, overridden_fields

import 'package:altme/app/shared/widget/image_card_text.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:altme/credentials/models/voucher/offer/offer.dart';
import 'package:altme/credentials/widgets/card_animation.dart';
import 'package:altme/credentials/widgets/credential_container.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable(explicitToJson: true)
class Voucher extends CredentialSubject {
  Voucher(
    this.id,
    this.type,
    this.issuedBy,
    this.identifier,
    this.offer,
  ) : super(id, type, issuedBy);

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String identifier;
  final Offer offer;
  @override
  final Author issuedBy;

  @override
  Map<String, dynamic> toJson() => _$VoucherToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: VoucherRecto(item));
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: VoucherRecto(item));
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 584 / 317,
          child: SizedBox(
            height: 317,
            width: 584,
            child: CardAnimation(
              recto: VoucherRecto(item),
              verso: VoucherVerso(item),
            ),
          ),
        ),
      ],
    );
  }
}

class VoucherDelegate extends MultiChildLayoutDelegate {
  VoucherDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('voucherValue')) {
      layoutChild('voucherValue', BoxConstraints.loose(size));
      positionChild(
        'voucherValue',
        Offset(size.width * 0.27, size.height * 0.95),
      );
    }
  }

  @override
  bool shouldRelayout(covariant VoucherDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class TextWithVoucherStyle extends StatelessWidget {
  const TextWithVoucherStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ImageCardText(
          text: value,
          textStyle: Theme.of(context).textTheme.voucherOverlay,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class VoucherRecto extends Recto {
  const VoucherRecto(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/carte-coupon-recto.png',
          ),
        ),
      ),
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: CustomMultiChildLayout(
            delegate: VoucherVersoDelegate(position: Offset.zero),
            children: const [
              // LayoutId(
              //   id: 'name',
              //   child: DisplayNameCard(item),
              // ),
              // LayoutId(
              //   id: 'description',
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //         right: 250 * MediaQuery.of(context).size.aspectRatio),
              //     child: DisplayDescriptionCard(item),
              //   ),
              // ),
              // LayoutId(
              //   id: 'issuer',
              //   child: Row(
              //     children: [
              //       Container(
              //           height: 30,
              //           child: ImageFromNetwork(
              //             item.credentialPreview.credentialSubject.issuedBy
              //                 .logo,
              //             fit: BoxFit.cover,
              //           )),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherVerso extends Verso {
  const VoucherVerso(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;
  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;
    // final credentialSubject = item.credentialPreview.credentialSubject;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/carte-coupon-verso.png',
          ),
        ),
      ),
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: CustomMultiChildLayout(
            delegate: VoucherVersoDelegate(position: Offset.zero),
            children: const [
              // LayoutId(
              //   id: 'name',
              //   child: DisplayNameCard(item),
              // ),
              // LayoutId(
              //   id: 'description',
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //         right: 250 * MediaQuery.of(context).size.aspectRatio),
              //     child: DisplayDescriptionCard(item),
              //   ),
              // ),
              // LayoutId(
              //   id: 'issuer',
              //   child: Row(
              //     children: [
              //       Container(
              //           height: 30,
              //           child: ImageFromNetwork(
              //             item.credentialPreview.credentialSubject.issuedBy
              //                 .logo,
              //             fit: BoxFit.cover,
              //           )),
              //       SizedBox(width: 10),
              //       Row(
              //         children: [
              //           Text(
              //             '${l10n.personalMail}: ',
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .credentialTextCard
              //                 .copyWith(fontWeight: FontWeight.bold),
              //           ),
              //           credentialSubject is Voucher
              //               ? Text(
              //                   credentialSubject.offer.value,
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .credentialTextCard,
              //                 )
              //               : SizedBox.shrink(),
              //         ],
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherVersoDelegate extends MultiChildLayoutDelegate {
  VoucherVersoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.14));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
        'description',
        Offset(size.width * 0.06, size.height * 0.33),
      );
    }

    if (hasChild('issuer')) {
      layoutChild('issuer', BoxConstraints.loose(size));
      positionChild('issuer', Offset(size.width * 0.06, size.height * 0.783));
    }
  }

  @override
  bool shouldRelayout(VoucherVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
