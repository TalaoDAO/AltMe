import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
    super.key,
    required this.title,
    this.passwordDigits = 4,
    required this.passwordEnteredCallback,
    required this.cancelButton,
    required this.deleteButton,
    this.shouldTriggerVerification,
    this.isValidCallback,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    this.bottomWidget,
    this.backgroundColor,
    this.cancelCallback,
    this.subTitle,
    this.header,
    this.allowAction = true,
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig();

  final Widget? header;
  final String title;
  final String? subTitle;
  final int passwordDigits;
  final PasswordEnteredCallback passwordEnteredCallback;
  final bool allowAction;

  // Cancel button and delete button will be switched based on the screen state
  final Widget cancelButton;
  final Widget deleteButton;
  final Stream<bool>? shouldTriggerVerification;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback? isValidCallback;
  final CancelCallback? cancelCallback;

  final Color? backgroundColor;
  final Widget? bottomWidget;

  @override
  State<StatefulWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool>? streamSubscription;
  late AnimationController controller;
  late Animation<double> animation;

  final log = getLogger('PinCodeWidget');

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerVerification?.listen(_showValidation);
    controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    final Animation<double> curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = Tween<double>(begin: 0, end: 10).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<PinCodeViewCubit>().setEnteredPasscode('');
          controller.value = 0;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PinCodeViewCubit, PinCodeViewState>(
      builder: (context, state) {
        final PinCodeViewCubit pinCodeViewCubit =
            context.read<PinCodeViewCubit>();
        final enteredPasscode = pinCodeViewCubit.state.enteredPasscode;

        return OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (widget.header != null)
                                  widget.header!
                                else
                                  const AltMeLogo(size: Sizes.logoLarge),
                                const SizedBox(height: Sizes.spaceNormal),
                                PinCodeTitle(
                                  title: widget.title,
                                  subTitle: widget.allowAction
                                      ? widget.subTitle
                                      : l10n.pincodeAttemptMessage,
                                  allowAction: widget.allowAction,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  height: 40,
                                  child: AnimatedBuilder(
                                    animation: animation,
                                    builder: (_, __) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          widget.passwordDigits,
                                          (index) => Container(
                                            margin: const EdgeInsets.all(8),
                                            child: Circle(
                                              allowAction: widget.allowAction,
                                              filled: index <
                                                  enteredPasscode.length,
                                              circleUIConfig:
                                                  widget.circleUIConfig,
                                              extraSize: animation.value,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                NumKeyboard(
                                  passwordEnteredCallback:
                                      widget.passwordEnteredCallback,
                                  keyboardUIConfig: widget.keyboardUIConfig,
                                  passwordDigits: widget.passwordDigits,
                                  cancelCallback: widget.cancelCallback,
                                  allowAction: widget.allowAction,
                                ),
                                widget.bottomWidget ?? Container()
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: DeleteButton(
                                  cancelButton: widget.cancelButton,
                                  deleteButton: widget.deleteButton,
                                  cancelCallback: widget.cancelCallback,
                                  keyboardUIConfig: widget.keyboardUIConfig,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (widget.header != null)
                                            widget.header!
                                          else
                                            const AltMeLogo(
                                              size: Sizes.logoLarge,
                                            ),
                                          const SizedBox(
                                            height: Sizes.spaceNormal,
                                          ),
                                          PinCodeTitle(
                                            title: widget.title,
                                            subTitle: widget.subTitle,
                                            allowAction: widget.allowAction,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            height: 40,
                                            child: AnimatedBuilder(
                                              animation: animation,
                                              builder: (_, __) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: List.generate(
                                                    widget.passwordDigits,
                                                    (index) => Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                        8,
                                                      ),
                                                      child: Circle(
                                                        allowAction:
                                                            widget.allowAction,
                                                        filled: index <
                                                            enteredPasscode
                                                                .length,
                                                        circleUIConfig: widget
                                                            .circleUIConfig,
                                                        extraSize:
                                                            animation.value,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (widget.bottomWidget != null)
                                    Positioned(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: widget.bottomWidget,
                                      ),
                                    )
                                  else
                                    Container()
                                ],
                              ),
                            ),
                            Expanded(
                              child: NumKeyboard(
                                passwordEnteredCallback:
                                    widget.passwordEnteredCallback,
                                keyboardUIConfig: widget.keyboardUIConfig,
                                passwordDigits: widget.passwordDigits,
                                cancelCallback: widget.cancelCallback,
                                allowAction: widget.allowAction,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: DeleteButton(
                            cancelButton: widget.cancelButton,
                            deleteButton: widget.deleteButton,
                            cancelCallback: widget.cancelCallback,
                            keyboardUIConfig: widget.keyboardUIConfig,
                          ),
                        ),
                      )
                    ],
                  );
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(PinCodeWidget old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerVerification != old.shouldTriggerVerification) {
      streamSubscription?.cancel();
      streamSubscription =
          widget.shouldTriggerVerification?.listen(_showValidation);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  void _showValidation(bool isValid) {
    if (isValid) {
      _validationCallback();
    } else {
      controller.forward();
    }
  }

  void _validationCallback() {
    if (widget.isValidCallback != null) {
      widget.isValidCallback!.call();
    } else {
      Navigator.maybePop(context);
      log.w(
        '''You didn't implement validation callback. Please handle a state by yourself then.''',
      );
    }
  }
}
