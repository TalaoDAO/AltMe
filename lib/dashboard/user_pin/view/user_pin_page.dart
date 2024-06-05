import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPinPage extends StatelessWidget {
  const UserPinPage({
    super.key,
    required this.onProceed,
    required this.onCancel,
    required this.txCode,
  });

  final void Function(String pincode) onProceed;
  final Function onCancel;
  final TxCode? txCode;

  static Route<dynamic> route({
    required void Function(String pincode) onProceed,
    required Function onCancel,
    required TxCode? txCode,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => UserPinPage(
        onProceed: onProceed,
        onCancel: onCancel,
        txCode: txCode,
      ),
      settings: const RouteSettings(name: '/UserPinPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCodeViewCubit(),
      child: UserPinView(
        onCancel: onCancel,
        onProceed: onProceed,
        txCode: txCode,
      ),
    );
  }
}

class UserPinView extends StatefulWidget {
  const UserPinView({
    super.key,
    required this.onProceed,
    required this.onCancel,
    required this.txCode,
  });

  final void Function(String pincode) onProceed;
  final Function onCancel;
  final TxCode? txCode;

  @override
  State<UserPinView> createState() => _UserPinViewState();
}

class _UserPinViewState extends State<UserPinView> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  String? pinCodeValue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrollView: false,
        body: PinCodeWidget(
          title: widget.txCode?.description ??
              l10n.pleaseInsertTheSecredCodeReceived,
          passwordDigits: widget.txCode?.length ?? 4,
          deleteButton: Text(
            l10n.delete,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          cancelButton: Text(
            l10n.cancel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          cancelCallback: _onPasscodeCancelled,
          isValidCallback: () {
            Navigator.pop(context);
            widget.onProceed
                .call(context.read<PinCodeViewCubit>().state.enteredPasscode);
          },
          isUserPin: true,
        ),
      ),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.of(context).pop();
    widget.onCancel.call();
  }
}
