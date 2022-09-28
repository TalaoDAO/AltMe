import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class BeaconRightPage extends StatelessWidget {
  const BeaconRightPage({
    Key? key,
    required this.p2pPeer,
  }) : super(key: key);

  final P2PPeer p2pPeer;

  static Route route({required P2PPeer p2pPeer}) {
    return MaterialPageRoute<void>(
      builder: (_) => BeaconRightPage(p2pPeer: p2pPeer),
      settings: const RouteSettings(name: '/BeaconRightPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BeaconRightCubit(
        beacon: Beacon(),
        beaconRepository: BeaconRepository(secure_storage.getSecureStorage),
      ),
      child: BeaconRightView(p2pPeer: p2pPeer),
    );
  }
}

class BeaconRightView extends StatelessWidget {
  const BeaconRightView({
    Key? key,
    required this.p2pPeer,
  }) : super(key: key);

  final P2PPeer p2pPeer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<BeaconRightCubit, BeaconRightState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }

        if (state.status == AppStatus.success) {
          Navigator.of(context).pop();
        }
      },
      child: BasePage(
        scrollView: false,
        title: l10n.rights,
        titleLeading: const BackLeadingButton(),
        body: BackgroundCard(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.spaceXSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    p2pPeer.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Sizes.spaceXLarge),
                  const Permissions(),
                  const SizedBox(height: Sizes.spaceXLarge),
                ],
              ),
            ),
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
              text: l10n.disconnectAndRevokeRights,
              onPressed: () {
                BeCarefulDialog.show(
                  context: context,
                  title: l10n.revokeAllRights,
                  subtitle: '${l10n.revokeSubtitleMessage} on ${p2pPeer.name}?',
                  no: l10n.cancel,
                  yes: l10n.revokeAll,
                  onContinueClick: () {
                    context
                        .read<BeaconRightCubit>()
                        .disconnect(publicKey: p2pPeer.publicKey);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
