import 'package:altme/app/shared/enum/message/response_string/response_string.dart';
import 'package:altme/app/shared/message_handler/response_message.dart';
import 'package:altme/app/shared/widget/button/my_outlined_button.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefuseButton extends StatelessWidget {
  const RefuseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MyOutlinedButton(
      text: l10n.communicationHostDeny,
      onPressed: () {
        Navigator.of(context).pop();
        final qrCodeScanCubit = context.read<QRCodeScanCubit>();
        qrCodeScanCubit.emitError(
          error: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
          ),
        );
      },
    );
  }
}
