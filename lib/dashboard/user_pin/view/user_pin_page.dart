import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPinPage extends StatelessWidget {
  const UserPinPage({
    super.key,
    required this.onProceed,
    required this.onCancel,
  });

  final void Function(String pincode) onProceed;
  final Function onCancel;

  static Route<dynamic> route({
    required void Function(String pincode) onProceed,
    required Function onCancel,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => UserPinPage(
        onProceed: onProceed,
        onCancel: onCancel,
      ),
      settings: const RouteSettings(name: '/UserPinPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PinCodeViewCubit(profileCubit: context.read<ProfileCubit>()),
      child: UserPinView(
        onCancel: onCancel,
        onProceed: onProceed,
      ),
    );
  }
}

class UserPinView extends StatefulWidget {
  const UserPinView({
    super.key,
    required this.onProceed,
    required this.onCancel,
  });

  final void Function(String pincode) onProceed;
  final Function onCancel;

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<PinCodeViewCubit, PinCodeViewState>(
        builder: (context, state) {
          return BasePage(
            backgroundColor: Theme.of(context).colorScheme.background,
            scrollView: false,
            body: PinCodeWidget(
              title: l10n.pleaseInsertTheSecredCodeReceived,
              passwordEnteredCallback: (String enterPasscode) {
                _verificationNotifier.add(true);
              },
              passwordDigits: 6,
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
                widget.onProceed.call(state.enteredPasscode);
              },
              doneButton: state.enteredPasscode.length < 4
                  ? null
                  : CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onProceed.call(state.enteredPasscode);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        child: Text(
                          l10n.proceed,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
              shouldTriggerVerification: _verificationNotifier.stream,
            ),
          );
        },
      ),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.of(context).pop();
    widget.onCancel.call();
  }
}
