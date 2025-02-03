import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class KYCButton extends StatelessWidget {
  const KYCButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MyElevatedButton(
      onPressed: () async {
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(
              top: 24,
              bottom: 16,
              left: 24,
              right: 24,
            ),
            title: Text(
              l10n.needEmailPass,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.shortestSide * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MyOutlinedButton(
                          borderColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          textColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          text: l10n.ok,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      text: l10n.verifyMe,
    );
  }
}
