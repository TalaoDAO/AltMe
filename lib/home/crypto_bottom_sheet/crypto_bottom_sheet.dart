import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class CryptoBottomSheet extends StatelessWidget {
  const CryptoBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final l10n = context.l10n;

        final List<CryptoAccountData> cryptoAccount = state.cryptoAccount.data;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              Text(
                l10n.cryptoAccounts,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(height: 10),
              ListView.builder(
                itemCount: cryptoAccount.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  final cryptoAccountData = cryptoAccount[i];
                  final walletAddress = cryptoAccountData.walletAddress;

                  final walletAddressExtracted = walletAddress != ''
                      ? '''${walletAddress.substring(0, 5)} ... ${walletAddress.substring(walletAddress.length - 5)}'''
                      : '';
                  return Container(
                    color: Colors.grey.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${l10n.cryptoAccount} ${i + 1}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              walletAddressExtracted,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Container(height: 20),
              MyElevatedButton(
                text: l10n.cryptoAddAccount,
                verticalSpacing: 8,
                fontSize: 15,
                onPressed: () async {
                  final String? ssiMnemonic =
                      await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
                  await context
                      .read<WalletCubit>()
                      .createCryptoWallet(mnemonic: ssiMnemonic!);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
