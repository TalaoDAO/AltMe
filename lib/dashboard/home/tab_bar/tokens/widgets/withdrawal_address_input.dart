import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawalAddressInputView extends StatelessWidget {
  const WithdrawalAddressInputView({
    Key? key,
    this.caption,
    this.withdrawalAddressController,
  }) : super(key: key);

  final String? caption;
  final TextEditingController? withdrawalAddressController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WithdrawalInputCubit(),
      child: _WithdrawalAddressInputPage(
        withdrawalAddressController: withdrawalAddressController,
        caption: caption,
      ),
    );
  }
}

class _WithdrawalAddressInputPage extends StatefulWidget {
  const _WithdrawalAddressInputPage({
    Key? key,
    this.caption,
    this.withdrawalAddressController,
  }) : super(key: key);

  final String? caption;
  final TextEditingController? withdrawalAddressController;

  @override
  State<_WithdrawalAddressInputPage> createState() =>
      _WithdrawalAddressInputPageState();
}

class _WithdrawalAddressInputPageState
    extends State<_WithdrawalAddressInputPage> with WalletAddressValidator {
  late final withdrawalAddressController =
      widget.withdrawalAddressController ?? TextEditingController();

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
              style: Theme.of(context).textTheme.caption?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    controller: withdrawalAddressController,
                    style: Theme.of(context).textTheme.labelMedium,
                    textInputAction: TextInputAction.done,
                    maxLines: 2,
                    validator: (value) {
                      if (validateWalletAddress(value)) {
                        return null;
                      } else {
                        return l10n.notAValidWalletAddress;
                      }
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
                    ? InkWell(
                        onTap: _openQRScanner,
                        child: Image.asset(
                          IconStrings.scanAddress,
                          width: Sizes.icon2x,
                        ),
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
}
