import 'package:altme/credentials/credential.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DisplayStatus extends StatelessWidget {
  const DisplayStatus({
    required this.item,
    required this.displayLabel,
    Key? key,
  }) : super(key: key);

  final CredentialModel item;
  final bool displayLabel;

  @override
  Widget build(BuildContext context) {
    //TODO remove logic
    //final wallet = context.read<WalletCubit>();
    final currentRevocationStatus = item.revocationStatus;

    final localizations = S.of(context);
    return FutureBuilder(
      future: item.status,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (currentRevocationStatus == RevocationStatus.unknown) {
            //TODO remove logic
            //wallet.handleUnknownRevocationStatus(item);
          }
          switch (snapshot.data) {
            case CredentialStatus.active:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.activeCredential,
                    ),
                  ),
                  if (displayLabel)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        localizations.active,
                        style: Theme.of(context).textTheme.caption!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .activeCredential,
                            ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              );
            case CredentialStatus.expired:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.alarm_off,
                      color: Theme.of(context).colorScheme.expiredCredential,
                    ),
                  ),
                  if (displayLabel)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        localizations.expired,
                        style: Theme.of(context).textTheme.caption!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .expiredCredential,
                            ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              );
            case CredentialStatus.revoked:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.block,
                      color: Theme.of(context).colorScheme.revokedCredential,
                    ),
                  ),
                  if (displayLabel)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        localizations.revoked,
                        style: Theme.of(context).textTheme.caption!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .revokedCredential,
                            ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
