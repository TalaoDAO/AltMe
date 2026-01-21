import 'package:altme/app/shared/widget/dialog/confirm_dialog.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> deleteCredential(BuildContext context, String id) async {
  final l10n = context.l10n;
  final confirm =
      await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return ConfirmDialog(
            title: l10n.credentialDetailDeleteConfirmationDialog,
            yes: l10n.credentialDetailDeleteConfirmationDialogYes,
            no: l10n.credentialDetailDeleteConfirmationDialogNo,
          );
        },
      ) ??
      false;

  if (confirm) {
    final credentialsCubit = context.read<CredentialsCubit>();
    await credentialsCubit.deleteById(id: id);
  }
}
