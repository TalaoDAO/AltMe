import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class BeaconConfirmConnectionPage extends StatelessWidget {
  const BeaconConfirmConnectionPage({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const BeaconConfirmConnectionPage(),
      settings: const RouteSettings(name: '/beaconConfirmConnectionPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BeaconConfirmConnectionCubit(
        beacon: Beacon(),
        beaconCubit: context.read<BeaconCubit>(),
        walletCubit: context.read<WalletCubit>(),
        beaconRepository: BeaconRepository(secure_storage.getSecureStorage),
      ),
      child: const BeaconConfirmConnectionView(),
    );
  }
}

class BeaconConfirmConnectionView extends StatelessWidget {
  const BeaconConfirmConnectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<BeaconConfirmConnectionCubit,
        BeaconConfirmConnectionState>(
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
      child: WillPopScope(
        onWillPop: () async {
          context.read<BeaconConfirmConnectionCubit>().rejectConnection();
          return true;
        },
        child: BasePage(
          scrollView: false,
          title: l10n.connection,
          titleLeading: BackLeadingButton(
            onPressed: () =>
                context.read<BeaconConfirmConnectionCubit>().rejectConnection(),
          ),
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
                      context
                          .read<BeaconCubit>()
                          .state
                          .beaconRequest!
                          .request!
                          .appMetadata!
                          .name!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Sizes.spaceXLarge),
                    const Permissions(),
                    const SizedBox(height: Sizes.spaceXLarge),
                    const SelectAccount(),
                    const SizedBox(
                      height: Sizes.spaceNormal,
                    ),
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
                text: l10n.connect,
                onPressed: () {
                  context.read<BeaconConfirmConnectionCubit>().connect();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
