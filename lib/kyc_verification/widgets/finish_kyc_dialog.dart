import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class FinishKycDialog extends StatelessWidget {
  const FinishKycDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.shortestSide * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DialogCloseButton(),
              const SizedBox(height: Sizes.spaceSmall),
              Icon(
                Icons.access_time_filled_rounded,
                size: Sizes.icon4x,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Text(
                l10n.finishedVerificationTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Text(
                l10n.finishedVerificationDescription,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceSmall),
            ],
          ),
        ),
      ),
    );
  }
}
