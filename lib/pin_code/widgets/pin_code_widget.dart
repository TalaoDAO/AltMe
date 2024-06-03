import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
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
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig();

  final OnLoginAttempt? onLoginAttempt;
  final Widget? header;
  final String title;
  final String? subTitle;
  final int passwordDigits;
  final bool isNewCode;

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

  @override
  State<StatefulWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget>
    with SingleTickerProviderStateMixin {
  late bool isPincodeDifferent;

  final log = getLogger('PinCodeWidget');

  @override
  void initState() {
    super.initState();
    isPincodeDifferent = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<PinCodeViewCubit, PinCodeViewState>(
      listenWhen: (previous, current) {
        if (current.enteredPasscode.length < widget.passwordDigits) {
          setState(() {
            isPincodeDifferent = false;
          });
        }
        if (current.enteredPasscode.length == widget.passwordDigits) {
          if (current.isPinCodeValid) {
            _validationCallback();
          } else {
            if (widget.title == l10n.confirmYourPinCode) {
              setState(() {
                isPincodeDifferent = true;
              });
            }
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
        final titleStyle = Theme.of(context).textTheme.labelMedium;

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
                                    profileModel: context
                                        .read<ProfileCubit>()
                                        .state
                                        .model,
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
                                const SizedBox(height: Sizes.spaceXSmall),
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
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
                                          circleUIConfig: (state
                                                      .isPincodeSequence ||
                                                  state.isPincodeSeries ||
                                                  isPincodeDifferent)
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
                                SizedBox(
                                  height: Sizes.spaceSmall,
                                  child: isPincodeDifferent
                                      ? Text(
                                          l10n.pincodeDifferent,
                                          style: titleStyle?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : state.isPincodeSeries
                                          ? Text(
                                              l10n.pincodeSerie,
                                              style: titleStyle?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          : state.isPincodeSequence
                                              ? Text(
                                                  l10n.pincodeSequence,
                                                  style: titleStyle?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              : const SizedBox.shrink(),
                                ),
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
                                ],
                              ),
                            ),
                            Expanded(
                              child: NumKeyboard(
                                keyboardUIConfig: widget.keyboardUIConfig,
                                passwordDigits: widget.passwordDigits,
                                cancelCallback: widget.cancelCallback,
                                allowAction: true,
                                keyboardButton: KeyboardButton(widget: widget),
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
