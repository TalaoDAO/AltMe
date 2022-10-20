import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialBaseWidget extends StatelessWidget {
  const CredentialBaseWidget({
    Key? key,
    required this.cardBackgroundImagePath,
    this.aspectRatio = Sizes.credentialAspectRatio,
    this.issuerName,
    this.value,
    this.issuanceDate,
    this.expirationDate,
  }) : super(key: key);

  final String cardBackgroundImagePath;
  final double aspectRatio;
  final String? issuerName;
  final String? value;
  final String? issuanceDate;
  final String? expirationDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CredentialImage(
      image: cardBackgroundImagePath,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CustomMultiChildLayout(
          delegate: CredentialBaseWidgetDelegate(position: Offset.zero),
          children: [
            if (issuerName != null && issuerName!.isNotEmpty)
              LayoutId(
                id: 'provided-by',
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  heightFactor: 0.11,
                  child: MyText(
                    '${l10n.providedBy} $issuerName',
                    style: Theme.of(context).textTheme.identitiyBaseLightText,
                  ),
                ),
              ),
            if (value != null)
              LayoutId(
                id: 'value',
                child: FractionallySizedBox(
                  widthFactor: 0.65,
                  heightFactor: 0.12,
                  child: MyText(
                    value!,
                    style: Theme.of(context).textTheme.identitiyBaseBoldText,
                  ),
                ),
              ),
            if (issuanceDate != null)
              LayoutId(
                id: 'issued-on',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    l10n.issuedOn,
                    style: Theme.of(context).textTheme.identitiyBaseLightText,
                  ),
                ),
              ),
            if (issuanceDate != null)
              LayoutId(
                id: 'issued-on-value',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    issuanceDate!,
                    style: Theme.of(context).textTheme.identitiyBaseBoldText,
                  ),
                ),
              ),
            if (expirationDate != '--')
              LayoutId(
                id: 'expiration-date',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    l10n.expirationDate,
                    style: Theme.of(context).textTheme.identitiyBaseLightText,
                  ),
                ),
              ),
            if (expirationDate != '--')
              LayoutId(
                id: 'expiration-date-value',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    expirationDate!,
                    style: Theme.of(context).textTheme.identitiyBaseBoldText,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CredentialBaseWidgetDelegate extends MultiChildLayoutDelegate {
  CredentialBaseWidgetDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('provided-by')) {
      layoutChild('provided-by', BoxConstraints.loose(size));
      positionChild(
        'provided-by',
        Offset(size.width * 0.06, size.height * 0.28),
      );
    }

    if (hasChild('value')) {
      layoutChild('value', BoxConstraints.loose(size));
      positionChild(
        'value',
        Offset(size.width * 0.06, size.height * 0.50),
      );
    }

    if (hasChild('issued-on')) {
      layoutChild('issued-on', BoxConstraints.loose(size));
      positionChild(
        'issued-on',
        Offset(size.width * 0.06, size.height * 0.70),
      );
    }
    if (hasChild('issued-on-value')) {
      layoutChild('issued-on-value', BoxConstraints.loose(size));
      positionChild(
        'issued-on-value',
        Offset(size.width * 0.06, size.height * 0.82),
      );
    }
    if (hasChild('expiration-date')) {
      layoutChild('expiration-date', BoxConstraints.loose(size));
      positionChild(
        'expiration-date',
        Offset(size.width * 0.5, size.height * 0.70),
      );
    }
    if (hasChild('expiration-date-value')) {
      layoutChild('expiration-date-value', BoxConstraints.loose(size));
      positionChild(
        'expiration-date-value',
        Offset(size.width * 0.5, size.height * 0.82),
      );
    }
  }

  @override
  bool shouldRelayout(CredentialBaseWidgetDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
