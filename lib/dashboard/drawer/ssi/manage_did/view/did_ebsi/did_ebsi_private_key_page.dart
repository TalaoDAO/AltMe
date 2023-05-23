import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_storage/secure_storage.dart';

class DidEbsiPrivateKeyPage extends StatefulWidget {
  const DidEbsiPrivateKeyPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const DidEbsiPrivateKeyPage(),
      settings: const RouteSettings(name: '/DidEbsiPrivateKeyPage'),
    );
  }

  @override
  State<DidEbsiPrivateKeyPage> createState() => _DidEbsiPrivateKeyPageState();
}

class _DidEbsiPrivateKeyPageState extends State<DidEbsiPrivateKeyPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  Future<String> getPrivateKey() async {
    final ebsi = Ebsi(Dio());
    final mnemonic = await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
    final privateKey = await ebsi.privateKeyFromMnemonic(mnemonic: mnemonic!);
    return privateKey;
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    final Tween<double> rotationTween = Tween(begin: 20, end: 0);

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
      scrollView: false,
      title: l10n.decentralizedIDKey,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      secureScreen: true,
      body: BackgroundCard(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              l10n.didPrivateKey,
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            FutureBuilder<String>(
              future: getPrivateKey(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Column(
                      children: [
                        Text(
                          snapshot.data!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: Sizes.spaceXLarge),
                        CopyButton(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: snapshot.data),
                            );
                            AlertMessage.showStateMessage(
                              context: context,
                              stateMessage: StateMessage.success(
                                stringMessage: l10n.copiedToClipboard,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                    return const Text('');
                }
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
