import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPrivateKeyDialog extends StatelessWidget {
  const AccountPrivateKeyDialog({Key? key, this.onContinueClick})
      : super(key: key);

  final VoidCallback? onContinueClick;

  static void show({
    required BuildContext context,
    VoidCallback? onContinueClick,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider<ManageAccountDialogCubit>(
        create: (_) => ManageAccountDialogCubit(),
        child: AccountPrivateKeyDialog(
          onContinueClick: onContinueClick,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceNormal,
        vertical: Sizes.spaceSmall,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      content: BlocBuilder<ManageAccountDialogCubit, bool>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogCloseButton(
                showText: false,
                color: Theme.of(context).colorScheme.defaultDialogDark,
              ),
              Image.asset(
                IconStrings.alert,
                width: Sizes.icon4x,
              ),
              Text(
                l10n.beCareful,
                style: Theme.of(context).textTheme.caption2,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Text(
                l10n.privateKey,
                style: Theme.of(context).textTheme.defaultDialogTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Text(
                l10n.accountPrivateKeyAlert,
                style: Theme.of(context).textTheme.defaultDialogBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              CheckboxItem(
                value: state,
                text: l10n.iReadTheMessageCorrectly,
                textStyle: Theme.of(context).textTheme.defaultDialogBody,
                onChange: (value) {
                  context.read<ManageAccountDialogCubit>().toggleState();
                },
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Padding(
                padding: const EdgeInsets.all(Sizes.spaceNormal),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: MyOutlinedButton(
                        text: l10n.cancel.toUpperCase(),
                        verticalSpacing: 15,
                        fontSize: 15,
                        borderRadius: 12,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: Sizes.spaceNormal,
                    ),
                    Expanded(
                      child: MyElevatedButton(
                        text: l10n.proceed.toUpperCase(),
                        verticalSpacing: 15,
                        fontSize: 15,
                        borderRadius: 12,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: state
                            ? () {
                                Navigator.of(context).pop();
                                onContinueClick?.call();
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
