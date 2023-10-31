import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class OtherDidPrivateKeyPage extends StatefulWidget {
  const OtherDidPrivateKeyPage({
    super.key,
    required this.didKeyType,
  });

  final DidKeyType didKeyType;

  static Route<dynamic> route({
    required DidKeyType didKeyType,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => OtherDidPrivateKeyPage(
        didKeyType: didKeyType,
      ),
      settings: const RouteSettings(name: '/OtherDidPrivateKeyPage'),
    );
  }

  @override
  State<OtherDidPrivateKeyPage> createState() => _OtherDidPrivateKeyPageState();
}

class _OtherDidPrivateKeyPageState extends State<OtherDidPrivateKeyPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  Future<String> getKey() async {
    final privateKey = await getPrivateKey(
      secureStorage: getSecureStorage,
      didKeyType: DidKeyType.ebsiv3,
      oidc4vc: OIDC4VC(),
    );
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
      title: widget.didKeyType.getTitle(l10n),
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
              future: getKey(),
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
                              ClipboardData(text: snapshot.data!),
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
