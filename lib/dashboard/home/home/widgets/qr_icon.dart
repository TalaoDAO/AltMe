import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QRIcon extends StatelessWidget {
  const QRIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          if (kIsWeb) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => ConfirmDialog(
                title: l10n.unavailable_feature_title,
                subtitle: l10n.unavailable_feature_message,
                yes: l10n.ok,
                showNoButton: false,
              ),
            );
            return;
          } else {
            if (context.read<HomeCubit>().state.homeStatus ==
                HomeStatus.hasNoWallet) {
              showDialog<void>(
                context: context,
                builder: (_) => const WalletDialog(),
              );
              return;
            }
            Navigator.of(context).push<void>(QrCodeScanPage.route());
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary,
                    blurRadius: 5,
                    offset: Offset.zero,
                  ),
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.16),
                    blurRadius: 12,
                    spreadRadius: -12,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryFixedDim,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: ImageIcon(
                const AssetImage(IconStrings.scan),
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
