import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

/// Shows whether an issuer/verifier could be verified, per the active
/// profile's trust mechanism. Always rendered - warns but never blocks.
class TrustBadge extends StatelessWidget {
  const TrustBadge({
    super.key,
    required this.isTrusted,
    required this.trustedLabel,
    required this.notTrustedLabel,
    this.notTrustedDescription,
  });

  final bool isTrusted;
  final String trustedLabel;
  final String notTrustedLabel;
  final String? notTrustedDescription;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isTrusted ? colorScheme.primary : colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 30, color: color),
            const SizedBox(width: Sizes.spaceSmall),
            Flexible(
              child: Text(
                isTrusted ? trustedLabel : notTrustedLabel,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        if (!isTrusted && notTrustedDescription != null) ...[
          const SizedBox(height: 4),
          Text(
            notTrustedDescription!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
