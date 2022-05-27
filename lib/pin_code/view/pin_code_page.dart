import 'dart:async';

import 'package:altme/pin_code/view/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef PasswordEnteredCallback = void Function(String text);
typedef IsValidCallback = void Function();
typedef CancelCallback = void Function();

class PinCodePage extends StatefulWidget {

  const PinCodePage({
    Key? key,
    required this.title,
    this.passwordDigits = 6,
    required this.passwordEnteredCallback,
    required this.shouldTriggerVerification,
    this.isValidCallback,
    CircleUIConfig? circleUIConfig,
    this.bottomWidget,
    this.backgroundColor,
    this.cancelCallback,
    this.digits,
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        super(key: key);

  final Widget title;
  final int passwordDigits;
  final PasswordEnteredCallback passwordEnteredCallback;

  final Stream<bool> shouldTriggerVerification;
  final CircleUIConfig circleUIConfig;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback? isValidCallback;
  final CancelCallback? cancelCallback;

  final Color? backgroundColor;
  final Widget? bottomWidget;
  final List<String>? digits;


  @override
  State<StatefulWidget> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool> streamSubscription;
  String enteredPasscode = '';
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerVerification.listen(_showValidation);
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation =
        Tween<double>(begin: 0, end: 10).animate(curve as Animation<double>)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                enteredPasscode = '';
                controller.value = 0;
              });
            }
          })
          ..addListener(() {
            setState(() {
              // the animation object’s value is the changed state
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.black.withOpacity(0.8),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitPinCodePage()
                : _buildLandscapePinCodePage();
          },
        ),
      ),
    );
  }

  Widget _buildPortraitPinCodePage() => Stack(
        children: [
          Positioned(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.title,
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildCircles(),
                    ),
                  ),
                  widget.bottomWidget ?? Container()
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomRight,
              child: _buildDeleteButton(),
            ),
          ),
        ],
      );

  Widget _buildLandscapePinCodePage() => Stack(
        children: [
          Positioned(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.title,
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _buildCircles(),
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
                              child: widget.bottomWidget),
                        )
                      else
                        Container()
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomRight,
              child: _buildDeleteButton(),
            ),
          )
        ],
      );

  List<Widget> _buildCircles() {
    final list = <Widget>[];
    final config = widget.circleUIConfig;
    final extraSize = animation.value;
    for (int i = 0; i < widget.passwordDigits; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          child: Circle(
            filled: i < enteredPasscode.length,
            circleUIConfig: config,
            extraSize: extraSize,
          ),
        ),
      );
    }
    return list;
  }

  void _onDeleteCancelButtonPressed() {
    if (enteredPasscode.isNotEmpty) {
      setState(() {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
      });
    } else {
      widget.cancelCallback?.call();
    }
  }

  // void _onKeyboardButtonPressed(String text) {
  //   if (text == Keyboard.deleteButton) {
  //     _onDeleteCancelButtonPressed();
  //     return;
  //   }
  //   setState(() {
  //     if (enteredPasscode.length < widget.passwordDigits) {
  //       enteredPasscode += text;
  //       if (enteredPasscode.length == widget.passwordDigits) {
  //         widget.passwordEnteredCallback(enteredPasscode);
  //       }
  //     }
  //   });
  // }

  @override
  void didUpdateWidget(PinCodePage old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerVerification != old.shouldTriggerVerification) {
      streamSubscription.cancel();
      streamSubscription =
          widget.shouldTriggerVerification.listen(_showValidation);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  void _showValidation(bool isValid) {
    if (isValid) {
      Navigator.maybePop(context).then<void>((pop) => _validationCallback());
    } else {
      controller.forward();
    }
  }

  void _validationCallback() {
    if (widget.isValidCallback != null) {
      widget.isValidCallback!();
    } else {
      print(
          "You didn't implement validation callback. Please handle a state by yourself then.");
    }
  }

  Widget _buildDeleteButton() {
    return CupertinoButton(
      onPressed: _onDeleteCancelButtonPressed,
      child: Center(),
      // child: Container(
      //   child:
      //       enteredPasscode.isEmpty ? widget.cancelButton : widget.deleteButton,
      // ),
    );
  }
}
