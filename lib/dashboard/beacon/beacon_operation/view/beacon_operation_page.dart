import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeaconOperationPage extends StatelessWidget {
  const BeaconOperationPage({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const BeaconOperationPage(),
      settings: const RouteSettings(name: '/BeaconOperationPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BeaconOperationCubit(
        beacon: Beacon(),
        beaconCubit: context.read<BeaconCubit>(),
        walletCubit: context.read<WalletCubit>(),
        dioClient: DioClient('', Dio()),
      ),
      child: const BeaconOperationView(),
    );
  }
}

class BeaconOperationView extends StatelessWidget {
  const BeaconOperationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final BeaconRequest beaconRequest =
        context.read<BeaconCubit>().state.beaconRequest!;

    final amount =
        int.parse(beaconRequest.operationDetails!.first.amount!) / 1e6;

    const symbol = 'XTZ';

    return BlocConsumer<BeaconOperationCubit, BeaconOperationState>(
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
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            context.read<BeaconOperationCubit>().rejectOperation();
            return true;
          },
          child: BasePage(
            scrollView: false,
            title: l10n.confirm,
            titleLeading: BackLeadingButton(
              onPressed: () =>
                  context.read<BeaconOperationCubit>().rejectOperation(),
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
                        beaconRequest.request!.appMetadata!.name!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                      MyText(
                        '${amount.toStringAsFixed(6).formatNumber()} $symbol',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: Sizes.space2XSmall),
                      Text(
                        l10n.amount,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                      SenderReceiver(
                        from: beaconRequest.request!.sourceAddress!,
                        to: beaconRequest.operationDetails!.first.destination!,
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      Image.asset(
                        IconStrings.arrowDown,
                        height: Sizes.icon3x,
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                      ConfirmDetailsCard(
                        amount: amount,
                        symbol: symbol,
                        tokenUSDRate: state.xtzUSDRate,
                        networkFee: state.networkFee,
                        onEditButtonPressed: () async {
                          final NetworkFeeModel? networkFeeModel =
                              await SelectNetworkFeeBottomSheet.show(
                            context: context,
                            selectedNetworkFee: state.networkFee,
                          );

                          if (networkFeeModel != null) {
                            context
                                .read<BeaconOperationCubit>()
                                .setNetworkFee(networkFee: networkFeeModel);
                          }
                        },
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
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
                  text: l10n.send,
                  onPressed: () {
                    context.read<BeaconOperationCubit>().send();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
