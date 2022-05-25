import 'package:altme/app/shared/date/date.dart';
import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplayIssuanceDateWidget extends StatelessWidget {
  const DisplayIssuanceDateWidget(this.issuanceDate, this.textColor, {Key? key})
      : super(key: key);
  final String? issuanceDate;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = issuanceDate;
    if (date != null) {
      return CredentialField(
        value: UiDate.displayDate(l10n, date),
        title: l10n.issuanceDate,
        textColor: textColor,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
