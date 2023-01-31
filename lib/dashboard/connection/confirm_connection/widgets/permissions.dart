import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class Permissions extends StatelessWidget {
  const Permissions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.beaconBorder,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.requestPersmissionTo,
            style: Theme.of(context).textTheme.beaconRequestPermission,
          ),
          const SizedBox(height: 5),
          PermissionText(text: l10n.viewAccountBalanceAndNFTs),
          PermissionText(text: l10n.requestApprovalForTransaction),
        ],
      ),
    );
  }
}

class PermissionText extends StatelessWidget {
  const PermissionText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 20,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: MyText(
              text,
              style: Theme.of(context).textTheme.beaconPermissions,
            ),
          ),
        ],
      ),
    );
  }
}
