import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class LoadingView {
  factory LoadingView() => _shared;

  LoadingView._sharedInstance();

  static final LoadingView _shared = LoadingView._sharedInstance();

  LoadingViewController? controller;

  void show({required BuildContext context, String? text}) {
    final textValue = text ?? context.l10n.loading;
    if (controller?.update(textValue) ?? false) {
      return;
    } else {
      controller = showOverlay(context: context, text: textValue);
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingViewController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    // ignore: cast_nullable_to_non_nullable
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.grey[800]!.withAlpha(150),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(Sizes.spaceNormal),
              constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const AltMeLogo(size: Sizes.logoNormal),
                      const SizedBox(height: 20),
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshopt) {
                          if (snapshopt.hasData) {
                            return Text(
                              snapshopt.data.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.loadingText,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state?.insert(overlay);

    return LoadingViewController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
