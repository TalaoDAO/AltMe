import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawalAddressInputView extends StatelessWidget {
  const WithdrawalAddressInputView({
    super.key,
    this.caption,
    this.withdrawalAddressController,
    this.onValidAddress,
  });

  final String? caption;
  final TextEditingController? withdrawalAddressController;
  final dynamic Function(String)? onValidAddress;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WithdrawalInputCubit(),
      child: _WithdrawalAddressInputPage(
        withdrawalAddressController: withdrawalAddressController,
        caption: caption,
        onValidAddress: onValidAddress,
      ),
    );
  }
}

class _WithdrawalAddressInputPage extends StatefulWidget {
  const _WithdrawalAddressInputPage({
    this.caption,
    this.withdrawalAddressController,
    this.onValidAddress,
  });

  final String? caption;
  final TextEditingController? withdrawalAddressController;
  final dynamic Function(String)? onValidAddress;

  @override
  State<_WithdrawalAddressInputPage> createState() =>
      _WithdrawalAddressInputPageState();
}

class _WithdrawalAddressInputPageState
    extends State<_WithdrawalAddressInputPage> with WalletAddressValidator {
  late final withdrawalAddressController =
      widget.withdrawalAddressController ?? TextEditingController();

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.always;

  @override
  void initState() {
    Future.microtask(() {
      withdrawalAddressController.addListener(() {
        if (withdrawalAddressController.text.isEmpty) {
          context.read<WithdrawalInputCubit>().setState(isTextFieldEmpty: true);
        } else {
          context
              .read<WithdrawalInputCubit>()
              .setState(isTextFieldEmpty: false);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BackgroundCard(
      color: Theme.of(context).colorScheme.cardBackground,
      padding: const EdgeInsets.only(
        top: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        left: Sizes.spaceSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.caption != null)
            Text(
              widget.caption!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Form(
                  autovalidateMode: autoValidateMode,
                  key: formKey,
                  child: TextFormField(
                    controller: withdrawalAddressController,
                    style: Theme.of(context).textTheme.labelMedium,
                    textInputAction: TextInputAction.done,
                    maxLines: 2,
                    onChanged: (value) {
                      if (autoValidateMode == AutovalidateMode.disabled) {
                        formKey.currentState?.setState(() {
                          autoValidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    validator: (value) {
                      if (validateWalletAddress(value)) {
                        formKey.currentState?.setState(() {
                          autoValidateMode = AutovalidateMode.disabled;
                        });
                        formKey.currentState?.save();
                        return null;
                      } else {
                        return l10n.notAValidWalletAddress;
                      }
                    },
                    onSaved: (value) {
                      widget.onValidAddress?.call(value!);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: l10n.withdrawalInputHint,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.spaceSmall,
              ),
              BlocBuilder<WithdrawalInputCubit, bool>(
                builder: (_, isEmpty) => isEmpty
                    ? Row(
                        children: [
                          InkWell(
                            onTap: _openQRScanner,
                            child: Image.asset(
                              IconStrings.scanAddress,
                              width: Sizes.icon2x,
                            ),
                          ),
                          const SizedBox(width: Sizes.spaceSmall,),
                          InkWell(
                            onTap: _openWhiteList,
                            child: Image.asset(
                              IconStrings.whiteList,
                              width: Sizes.icon2x,
                            ),
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: withdrawalAddressController.clear,
                        child: Image.asset(
                          IconStrings.closeCircleWhite,
                          width: Sizes.icon2x,
                        ),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _openQRScanner() async {
    final result =
        await Navigator.push<String?>(context, QrScannerPage.route());
    if (result?.startsWith('ethereum:') ?? false) {
      withdrawalAddressController.text = result!.replaceAll('ethereum:', '');
    } else {
      withdrawalAddressController.text = result ?? '';
    }
  }

  Future<void> _openWhiteList() async {
    final result =
        await Navigator.push<String?>(context, WhiteListPage.route());
    withdrawalAddressController.text = result ?? '';
  }
}
