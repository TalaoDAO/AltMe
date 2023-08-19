import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return UserPinView(
      onCancel: onCancel,
      onProceed: onProceed,
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
  final TextEditingController pinController = TextEditingController();

  late final _selectionControls = Platform.isIOS
      ? AppCupertinoTextSelectionControls(onPaste: _onPaste)
      : AppMaterialTextSelectionControls(onPaste: _onPaste);

  Future<void> _onPaste(TextSelectionDelegate value) async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    if (text.isEmpty) {
      return;
    } else {
      _setPinControllerText(text);
    }
  }

  void _insertKey(String key) {
    final text = pinController.text;
    _setPinControllerText(text + key);
  }

  void _setPinControllerText(String text) {
    pinController.text = text;
    pinController.selection = TextSelection.fromPosition(
      TextPosition(offset: pinController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        widget.onCancel.call();
        return true;
      },
      child: BasePage(
        scrollView: false,
        titleLeading: BackLeadingButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onCancel.call();
          },
        ),
        body: BackgroundCard(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: Sizes.space2XLarge),
              Text(
                "Please insert your pin.????",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Sizes.space2XLarge),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  selectionControls: _selectionControls,
                  controller: pinController,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  cursorWidth: 4,
                  autofocus: false,
                  keyboardType: TextInputType.none,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  cursorRadius: const Radius.circular(4),
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.smallRadius),
                      ),
                    ),
                    hintText: '000000',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    suffixStyle:
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.7,
                      child: LayoutBuilder(
                        builder: (_, constraint) {
                          return NumericKeyboard(
                            allowAction: true,
                            keyboardUIConfig: KeyboardUIConfig(
                              digitShape: BoxShape.rectangle,
                              spacing: 40,
                              digitInnerMargin: EdgeInsets.zero,
                              keyboardRowMargin: EdgeInsets.zero,
                              digitBorderWidth: 0,
                              digitTextStyle: Theme.of(context)
                                  .textTheme
                                  .calculatorKeyboardDigitTextStyle,
                              keyboardSize: constraint.biggest,
                            ),
                            trailingButton: KeyboardButton(
                              digitShape: BoxShape.rectangle,
                              digitBorderWidth: 0,
                              semanticsLabel: 'delete',
                              icon: Image.asset(
                                IconStrings.keyboardDelete,
                                width: Sizes.icon2x,
                                color: Colors.white,
                              ),
                              allowAction: true,
                              onLongPress: (_) {},
                              onTap: (_) {
                                final text = pinController.text;
                                if (text.isNotEmpty) {
                                  String pincode = '';
                                  if (text.length > 1) {
                                    pincode =
                                        text.substring(0, text.length - 1);
                                  }
                                  _setPinControllerText(pincode);
                                }
                              },
                            ),
                            onKeyboardTap: _insertKey,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        navigation: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.spaceSmall,
              right: Sizes.spaceSmall,
              bottom: Sizes.spaceSmall,
            ),
            child: MyElevatedButton(
              borderRadius: Sizes.normalRadius,
              text: l10n.next,
              onPressed: () => widget.onProceed.call(pinController.text),
            ),
          ),
        ),
      ),
    );
  }
}
