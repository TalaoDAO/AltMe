import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnLoginAttempt = void Function(int, int);

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
    super.key,
    required this.title,
    this.passwordDigits = 4,
    required this.cancelButton,
    required this.deleteButton,
    this.isValidCallback,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    this.bottomWidget,
    this.backgroundColor,
    this.cancelCallback,
    this.subTitle,
    this.header,
    this.onLoginAttempt,
    this.isNewCode = false,
    this.isUserPin = false,
    this.showKeyboard = false,
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig();

  final OnLoginAttempt? onLoginAttempt;
  final Widget? header;
  final String title;
  final String? subTitle;
  final int passwordDigits;
  final bool isNewCode;
  // When a specific PIN is requested to get a credential
  final bool isUserPin;

  // Cancel button and delete button will be switched based on the screen state
  final Widget cancelButton;
  final Widget deleteButton;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback? isValidCallback;
  final CancelCallback? cancelCallback;

  final Color? backgroundColor;
  final Widget? bottomWidget;
  final bool showKeyboard;

  @override
  State<StatefulWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget>
    with SingleTickerProviderStateMixin {
  bool isConfirmationPage = false;

  final log = getLogger('PinCodeWidget');
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String _latestKey = '';
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final l10n = context.l10n;
      if (widget.title == l10n.confirmYourPinCode) {
        setState(() {
          isConfirmationPage = true;
        });
      }
      if (widget.showKeyboard) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_focusNode);
        });
        _controller.addListener(() {
          final currentText = _controller.text;

          if (currentText.length > _previousText.length) {
            _latestKey = currentText.substring(currentText.length - 1);
            context.read<PinCodeViewCubit>().onKeyboardButtonPressed(
                  passwordDigits: widget.passwordDigits,
                  text: _latestKey,
                  cancelCallback: widget.cancelCallback,
                  isNewCode: widget.isNewCode,
                );
          } else if (currentText.length < _previousText.length) {
            context
                .read<PinCodeViewCubit>()
                .onDeleteCancelButtonPressed(widget.cancelCallback);
          }
          _previousText = currentText;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<PinCodeViewCubit, PinCodeViewState>(
      listenWhen: (previous, current) {
        if (current.enteredPasscode.length == widget.passwordDigits) {
          if (current.pinCodeError == PinCodeErrors.none || widget.isUserPin) {
            _validationCallback();
          }
        }
        return previous.loginAttemptCount != current.loginAttemptCount;
      },
      listener: (context, state) {
        widget.onLoginAttempt
            ?.call(state.loginAttemptCount, state.loginAttemptsRemaining);
      },
      builder: (context, state) {
        final enteredPasscode = state.enteredPasscode;

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
                                  WalletLogo(
                                    height: 90,
                                    width: MediaQuery.of(context)
                                            .size
                                            .shortestSide *
                                        0.5,
                                    showPoweredBy: true,
                                  ),
                                const SizedBox(height: Sizes.spaceSmall),
                                PinCodeTitle(
                                  title: widget.title,
                                  subTitle: state.allowAction
                                      ? widget.subTitle
                                      : l10n.pincodeAttemptMessage,
                                  allowAction: state.allowAction,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      widget.passwordDigits,
                                      (index) => Container(
                                        margin: const EdgeInsets.all(8),
                                        child: Circle(
                                          allowAction: state.allowAction,
                                          filled:
                                              index < enteredPasscode.length,
                                          circleUIConfig: (state.pinCodeError !=
                                                  PinCodeErrors.none)
                                              ? CircleUIConfig(
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                )
                                              : widget.circleUIConfig,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                PinCodeErrorMessage(
                                  isConfirmationPage: isConfirmationPage,
                                ),
                                if (!widget.showKeyboard)
                                  NumKeyboard(
                                    keyboardUIConfig: widget.keyboardUIConfig,
                                    passwordDigits: widget.passwordDigits,
                                    cancelCallback: widget.cancelCallback,
                                    allowAction: true,
                                    isNewCode: widget.isNewCode,
                                    keyboardButton:
                                        KeyboardButton(widget: widget),
                                  ),
                                widget.bottomWidget ?? Container(),
                              ],
                            ),
                            if (widget.showKeyboard)
                              Offstage(
                                child: TextField(
                                  focusNode: _focusNode,
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
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
                                            // const AltMeLogo(
                                            //   size: Sizes.logoLarge,
                                            // ),
                                            const Center(),
                                          const SizedBox(
                                            height: Sizes.spaceNormal,
                                          ),
                                          PinCodeTitle(
                                            title: widget.title,
                                            subTitle: widget.subTitle,
                                            allowAction: state.allowAction,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(
                                                widget.passwordDigits,
                                                (index) => Container(
                                                  margin: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  child: Circle(
                                                    allowAction:
                                                        state.allowAction,
                                                    filled: index <
                                                        enteredPasscode.length,
                                                    circleUIConfig:
                                                        widget.circleUIConfig,
                                                  ),
                                                ),
                                              ),
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
                                    Container(),
                                  if (widget.showKeyboard)
                                    Offstage(
                                      child: TextField(
                                        focusNode: _focusNode,
                                        controller: _controller,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (!widget.showKeyboard)
                              Expanded(
                                child: NumKeyboard(
                                  keyboardUIConfig: widget.keyboardUIConfig,
                                  passwordDigits: widget.passwordDigits,
                                  cancelCallback: widget.cancelCallback,
                                  allowAction: true,
                                  keyboardButton:
                                      KeyboardButton(widget: widget),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        );
      },
    );
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

class PinCodeErrorMessage extends StatelessWidget {
  const PinCodeErrorMessage({
    required this.isConfirmationPage,
    super.key,
  });

  final bool isConfirmationPage;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<PinCodeViewCubit, PinCodeViewState>(
      builder: (context, state) {
        Widget errorWidget = const PinCodeErrorText('');
        switch (state.pinCodeError) {
          case PinCodeErrors.none:
            errorWidget = const PinCodeErrorText('');
          case PinCodeErrors.errorSerie:
            errorWidget = PinCodeErrorText(l10n.pincodeSerie);
          case PinCodeErrors.errorSequence:
            errorWidget = PinCodeErrorText(l10n.pincodeSequence);
          case PinCodeErrors.errorConfirmation:
          case PinCodeErrors.errorPinCode:
            if (isConfirmationPage) {
              errorWidget = PinCodeErrorText(l10n.pincodeDifferent);
            } else {
              errorWidget = PinCodeErrorText(
                // ignore: lines_longer_than_80_chars
                '${l10n.userPinIsIncorrect}\n${l10n.codeSecretIncorrectDescription(
                  state.loginAttemptsRemaining,
                  state.loginAttemptsRemaining == 1 ? '' : 's',
                )}',
              );
            }
        }
        return errorWidget;
      },
    );
  }
}

class PinCodeErrorText extends StatelessWidget {
  const PinCodeErrorText(
    this.errorText, {
    super.key,
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
      textAlign: TextAlign.center,
    );
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    required this.widget,
  });

  final PinCodeWidget widget;

  @override
  Widget build(BuildContext context) {
    return DeleteButton(
      cancelButton: widget.cancelButton,
      deleteButton: widget.deleteButton,
      cancelCallback: widget.cancelCallback,
      keyboardUIConfig: widget.keyboardUIConfig,
    );
  }
}
