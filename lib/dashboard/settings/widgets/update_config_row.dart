import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_ui/wallet_ui.dart';

/// Updates the enterprise wallet configuration in place, and shows the loading,
/// success and error states in the row.
class UpdateConfigRow extends StatefulWidget {
  const UpdateConfigRow({super.key});

  @override
  State<UpdateConfigRow> createState() => _UpdateConfigRowState();
}

class _UpdateConfigRowState extends State<UpdateConfigRow> {
  /// The enterprise state outlives this page, so a result is only shown once
  /// the row itself has started an update.
  bool _started = false;

  Future<void> _update() async {
    setState(() => _started = true);
    await context.read<EnterpriseCubit>().updateTheConfiguration(
      context.read<ManageNetworkCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.walletColors;

    return BlocBuilder<EnterpriseCubit, EnterpriseState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final loading = _started && state.status == AppStatus.loading;
        String? result;
        Color? resultColor;
        if (_started && state.status == AppStatus.success) {
          result = l10n.successfullyUpdatedEnterpriseAccount;
          resultColor = colors.feedbackSuccessContent;
        } else if (_started && state.status == AppStatus.error) {
          result = l10n.somethingsWentWrongTryAgainLater;
          resultColor = colors.feedbackErrorMain;
        }

        return WalletListItem(
          leading: const WalletIcon(WalletIconStrings.cached),
          title: l10n.updateYourWalletConfigNow,
          subtitle: result,
          subtitleColor: resultColor,
          showDivider: true,
          trailing: loading
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
          onTap: loading ? null : _update,
        );
      },
    );
  }
}
