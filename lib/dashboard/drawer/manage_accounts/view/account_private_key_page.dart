import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AccountPrivateKeyPage extends StatefulWidget {
  const AccountPrivateKeyPage({
    Key? key,
    required this.privateKey,
  }) : super(key: key);

  static Route route({
    required String privateKey,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => AccountPrivateKeyPage(privateKey: privateKey),
      settings: const RouteSettings(name: '/AccountPrivateKeyPage'),
    );
  }

  final String privateKey;

  @override
  State<AccountPrivateKeyPage> createState() => _AccountPrivateKeyPageState();
}

class _AccountPrivateKeyPageState extends State<AccountPrivateKeyPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    final Tween<double> _rotationTween = Tween(begin: 10, end: 0);

    animation = _rotationTween.animate(animationController)
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
      title: l10n.privateKey,
      titleAlignment: Alignment.topCenter,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleTrailing: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Text(
            timeFormatter(timeInSecond: animation.value.toInt()),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          );
        },
      ),
      secureScreen: true,
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceNormal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget.privateKey,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
                // const SizedBox(
                //   height: Sizes.spaceXLarge,
                // ),
                // CopyButton(
                //   onTap: () async {
                //     await Clipboard.setData(
                //       ClipboardData(
                //         text: privateKey,
                //       ),
                //     );
                //     AlertMessage.showStateMessage(
                //       context: context,
                //       stateMessage: StateMessage.success(
                //         stringMessage: l10n.copiedToClipboard,
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
