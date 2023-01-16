import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class DIDPrivateKeyPage extends StatefulWidget {
  const DIDPrivateKeyPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<DIDPrivateKeyCubit>(
        create: (_) =>
            DIDPrivateKeyCubit(secureStorageProvider: getSecureStorage),
        child: const DIDPrivateKeyPage(),
      ),
      settings: const RouteSettings(name: '/DIDPrivateKeyPage'),
    );
  }

  @override
  State<DIDPrivateKeyPage> createState() => _DIDPrivateKeyPageState();
}

class _DIDPrivateKeyPageState extends State<DIDPrivateKeyPage> {
  @override
  void initState() {
    Future.microtask(() => context.read<DIDPrivateKeyCubit>().initialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      title: l10n.decentralizedIDKey,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
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
            BlocBuilder<DIDPrivateKeyCubit, String>(
              builder: (context, state) {
                return Text(
                  state,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                );
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(Sizes.spaceXLarge),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       CopyButton(
            //         onTap: () async {
            //           await Clipboard.setData(
            //             ClipboardData(
            //               text: context.read<DIDPrivateKeyCubit>().state,
            //             ),
            //           );
            //           AlertMessage.showStateMessage(
            //             context: context,
            //             stateMessage: StateMessage.success(
            //               stringMessage: l10n.copySecretKeyToClipboard,
            //             ),
            //           );
            //         },
            //       ),
            //       // const SizedBox(
            //       //   width: Sizes.spaceXLarge,
            //       // ),
            //       //const ExportButton(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
