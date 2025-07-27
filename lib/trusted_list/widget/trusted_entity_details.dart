import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/widget/trusted_entity_electronic_address.dart';
import 'package:altme/trusted_list/widget/trusted_entity_postal_address.dart';
import 'package:flutter/material.dart';

/// Widget to display TrustedEntity details field by field
class TrustedEntityDetails extends StatelessWidget {
  const TrustedEntityDetails({super.key, required this.trustedEntity});
  final TrustedEntity trustedEntity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trustedEntity.name != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(trustedEntity.name!,
                style:
                    textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          ),
        if (trustedEntity.description != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(trustedEntity.description!, style: textTheme.bodyLarge),
          ),
        if (trustedEntity.postalAddress != null)
          TrustedEntityPostalAddress(
            postalAddress: trustedEntity.postalAddress!,
            textTheme: textTheme,
          ),
        if (trustedEntity.electronicAddress != null)
          TrustedEntityElectronicAddress(
            electronicAddress: trustedEntity.electronicAddress!,
            textTheme: textTheme,
          ),
      ],
    );
  }
}
