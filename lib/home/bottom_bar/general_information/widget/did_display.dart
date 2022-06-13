import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DIDDisplay extends StatelessWidget {
  const DIDDisplay({Key? key, required this.isEnterpriseUser})
      : super(key: key);

  final bool isEnterpriseUser;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<DIDCubit, DIDState>(
      builder: (context, state) {
        final did = state.status == AppStatus.success ? state.did! : '';
        var blockChainAddress = '';
        if (did.length > 7) {
          blockChainAddress = did.substring(7);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isEnterpriseUser) ...[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        '${l10n.blockChainDisplayMethod} : ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        // TODO(all): Can we change did method
                        //  name according to the user type?
                        AltMeStrings.defaultDIDMethodName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${l10n.blockChainAdress} : ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Expanded(
                      child: Text(
                        blockChainAddress != ''
                            ? '''${blockChainAddress.substring(0, 10)} ... ${blockChainAddress.substring(blockChainAddress.length - 10)}'''
                            : '',
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: blockChainAddress));
                  },
                  child: Text(l10n.adressDisplayCopy),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${l10n.didDisplayId} : ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Expanded(
                    child: Text(
                      did != ''
                          ? '''${did.substring(0, 10)} ... ${did.substring(did.length - 10)}'''
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: did));
                },
                child: Text(l10n.didDisplayCopy),
              ),
            ],
          ),
        );
      },
    );
  }
}
