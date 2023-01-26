import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DIDDisplay extends StatelessWidget {
  const DIDDisplay({super.key, required this.isEnterpriseUser});

  final bool isEnterpriseUser;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<DIDCubit, DIDState>(
      builder: (context, state) {
        final did = state.status == AppStatus.success ? state.did! : '';

        final WalletCubit walletCubit = context.read<WalletCubit>();

        final activeIndex = walletCubit.state.currentCryptoIndex;

        final walletAddress =
            walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        AltMeStrings.defaultDIDMethodName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Expanded(
                      child: Text(
                        walletAddress != ''
                            ? '''${walletAddress.substring(0, 10)} ... ${walletAddress.substring(walletAddress.length - 10)}'''
                            : '',
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
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
                    Clipboard.setData(ClipboardData(text: walletAddress));
                  },
                  child: Text(l10n.adressDisplayCopy),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${l10n.didDisplayId} : ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Expanded(
                    child: Text(
                      did != ''
                          ? '''${did.substring(0, 10)} ... ${did.substring(did.length - 10)}'''
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
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
