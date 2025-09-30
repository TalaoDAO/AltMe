import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageDidPage extends StatefulWidget {
  const ManageDidPage({super.key, required this.didKeyType});

  final DidKeyType didKeyType;

  static Route<dynamic> route({required DidKeyType didKeyType}) {
    return MaterialPageRoute<void>(
      builder: (_) => ManageDidPage(didKeyType: didKeyType),
      settings: const RouteSettings(name: '/ManageDidPage'),
    );
  }

  @override
  State<ManageDidPage> createState() => _ManageDidEbsiPageState();
}

class _ManageDidEbsiPageState extends State<ManageDidPage> {
  Future<String> getDid() async {
    final profileCubit = context.read<ProfileCubit>();

    final privateKey = await getPrivateKey(
      profileCubit: profileCubit,
      didKeyType: widget.didKeyType,
    );

    final (did, _) = await getDidAndKid(
      didKeyType: widget.didKeyType,
      privateKey: privateKey,
      profileCubit: profileCubit,
    );

    return did;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = widget.didKeyType.getTitle(l10n);
    return BasePage(
      title: title,
      titleAlignment: Alignment.topCenter,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<String>(
                future: getDid(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      final did = snapshot.data!;
                      return Did(did: did);
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    case ConnectionState.active:
                      return const SizedBox();
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.spaceNormal),
                child: Divider(),
              ),
              DidPrivateKey(
                route: DidPrivateKeyPage.route(didKeyType: widget.didKeyType),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
