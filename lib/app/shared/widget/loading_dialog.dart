import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    Key? key,
    this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final loadingText = text ?? l10n.loading;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Text(loadingText),
          ),
        ),
      ),
    );
  }
}
