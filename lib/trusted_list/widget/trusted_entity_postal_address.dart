import 'package:altme/trusted_list/model/postal_address.dart';
import 'package:flutter/material.dart';

class TrustedEntityPostalAddress extends StatelessWidget {
  const TrustedEntityPostalAddress({
    super.key,
    required this.postalAddress,
    required this.textTheme,
  });
  final PostalAddress postalAddress;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final fields = <Widget>[];
    if (postalAddress.streetAddress != null) {
      fields.add(
        Text(postalAddress.streetAddress!, style: textTheme.bodyLarge),
      );
    }
    if (postalAddress.postalCode != null) {
      fields.add(Text(postalAddress.postalCode!, style: textTheme.bodyLarge));
    }
    if (postalAddress.locality != null) {
      fields.add(Text(postalAddress.locality!, style: textTheme.bodyLarge));
    }
    if (postalAddress.countryName != null) {
      fields.add(Text(postalAddress.countryName!, style: textTheme.bodyLarge));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields,
      ),
    );
  }
}
