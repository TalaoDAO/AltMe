import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:passbase_flutter/passbase_flutter.dart';

class KYCButton extends StatelessWidget {
  const KYCButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Sending email and DID to passbase
    final hasMetadata =
        context.read<HomeCubit>().setKYCMetadata(context.read<WalletCubit>());
    final l10n = context.l10n;

    return hasMetadata
        ? Stack(
            children: [
              MyElevatedButton(
                onPressed: () {},
                text: '',
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Text('Not available'),
              ),
            ],
          )
        : MyElevatedButton(
            onPressed: () async {
              await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  contentPadding: const EdgeInsets.only(
                    top: 24,
                    bottom: 16,
                    left: 24,
                    right: 24,
                  ),
                  title: Text(
                    l10n.needEmailPass,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MyOutlinedButton(
                              borderColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              textColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              text: l10n.ok,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            text: l10n.verifyMe,
          );
  }
}
