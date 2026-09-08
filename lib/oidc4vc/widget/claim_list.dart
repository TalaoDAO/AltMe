import 'package:flutter/material.dart';

class ClaimEntry {
  const ClaimEntry({required this.label, required this.value});

  final String label;
  final String value;
}

/// Renders exactly the claim name/value pairs that will be included in a
/// credential, or disclosed to a verifier.
class ClaimList extends StatelessWidget {
  const ClaimList({super.key, required this.claims});

  final List<ClaimEntry> claims;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final claim in claims) ...[
          Text(claim.label, style: textTheme.bodySmall),
          Text(claim.value, style: textTheme.titleMedium),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
