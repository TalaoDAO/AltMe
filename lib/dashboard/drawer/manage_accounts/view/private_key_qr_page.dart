import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrivateKeyQrPage extends StatefulWidget {
  const PrivateKeyQrPage({
    super.key,
    required this.title,
    required this.data,
    required this.secondsLeft,
  });

  final String title;
  final String data;
  final double secondsLeft;

  static Route<dynamic> route({
    required String title,
    required String data,
    required double secondsLeft,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => PrivateKeyQrPage(
          data: data,
          title: title,
          secondsLeft: secondsLeft,
        ),
        settings: const RouteSettings(name: '/PrivateKeyQrPage'),
      );

  @override
  State<PrivateKeyQrPage> createState() => _PrivateKeyQrPageState();
}

class _PrivateKeyQrPageState extends State<PrivateKeyQrPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.secondsLeft.toInt()),
    );

    final Tween<double> rotationTween =
        Tween(begin: widget.secondsLeft, end: 0);

    animation = rotationTween.animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: widget.title,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      body: BackgroundCard(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: QrImage(
                data: widget.data,
                size: 200,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 10),
            CopyButton(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: widget.data),
                );
                AlertMessage.showStateMessage(
                  context: context,
                  stateMessage: StateMessage.success(
                    stringMessage: l10n.copiedToClipboard,
                  ),
                );
              },
            ),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Text(
                      timeFormatter(timeInSecond: animation.value.toInt()),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
