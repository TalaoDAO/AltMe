import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class RightsPage extends StatelessWidget {
  const RightsPage({
    Key? key,
    required this.savedDappData,
  }) : super(key: key);

  final SavedDappData savedDappData;

  static Route route({required SavedDappData savedDappData}) {
    return MaterialPageRoute<void>(
      builder: (_) => RightsPage(savedDappData: savedDappData),
      settings: const RouteSettings(name: '/RightsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RightsCubit(
        beacon: Beacon(),
        connectedDappRepository:
            ConnectedDappRepository(secure_storage.getSecureStorage),
        walletConnectCubit: context.read<WalletConnectCubit>(),
      ),
      child: RightsView(savedDappData: savedDappData),
    );
  }
}

class RightsView extends StatelessWidget {
  const RightsView({
    Key? key,
    required this.savedDappData,
  }) : super(key: key);

  final SavedDappData savedDappData;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<RightsCubit, RightsState>(
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
                    savedDappData.peer != null
                        ? savedDappData.peer!.name
                        : savedDappData.wcSessionStore!.remotePeerMeta.name,
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
                  subtitle:
                      '''${l10n.revokeSubtitleMessage} on ${savedDappData.peer != null ? savedDappData.peer!.name : savedDappData.wcSessionStore!.remotePeerMeta.name}?''',
                  no: l10n.cancel,
                  yes: l10n.revokeAll,
                  onContinueClick: () {
                    context
                        .read<RightsCubit>()
                        .disconnect(savedDappData: savedDappData);
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
