import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Did extends StatelessWidget {
  const Did({super.key, required this.did});

  final String did;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.did,
          style: Theme.of(context).textTheme.title,
        ),
        const SizedBox(
          height: Sizes.spaceNormal,
        ),
        Text(
          did,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Padding(
          padding: const EdgeInsets.all(Sizes.spaceXLarge),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CopyButton(
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: did,
                    ),
                  );
                  AlertMessage.showStateMessage(
                    context: context,
                    stateMessage: StateMessage.success(
                      stringMessage: l10n.copyDIDKeyToClipboard,
                    ),
                  );
                },
              ),
              // const SizedBox(
              //   width: Sizes.spaceXLarge,
              // ),
              //const ExportButton(),
            ],
          ),
        ),
      ],
    );
  }
}
