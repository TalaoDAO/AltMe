import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/tokens.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectNetworkFeeBottomSheet extends StatelessWidget {
  const SelectNetworkFeeBottomSheet({
    Key? key,
    required this.confirmWithdrawalCubit,
  }) : super(key: key);

  final ConfirmWithdrawalCubit confirmWithdrawalCubit;

  static Future<void> show({required BuildContext context}) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Sizes.largeRadius),
          topLeft: Radius.circular(Sizes.largeRadius),
        ),
      ),
      context: context,
      builder: (_) => SelectNetworkFeeBottomSheet(
        confirmWithdrawalCubit: context.read<ConfirmWithdrawalCubit>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelectNetworkFeeCubit>(
      create: (_) => SelectNetworkFeeCubit(
        selectedNetworkFee: confirmWithdrawalCubit.state.networkFee,
        confirmWithdrawalCubit: confirmWithdrawalCubit,
      ),
      child: const _SelectNetworkFeeBottomSheetView(),
    );
  }
}

class _SelectNetworkFeeBottomSheetView extends StatefulWidget {
  const _SelectNetworkFeeBottomSheetView({Key? key}) : super(key: key);

  @override
  State<_SelectNetworkFeeBottomSheetView> createState() =>
      _SelectNetworkFeeBottomSheetViewState();
}

class _SelectNetworkFeeBottomSheetViewState
    extends State<_SelectNetworkFeeBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.inversePrimary,
            blurRadius: 5,
            spreadRadius: -3,
          )
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Sizes.largeRadius),
          topLeft: Radius.circular(Sizes.largeRadius),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.changeFee,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Expanded(
                child:
                    BlocBuilder<SelectNetworkFeeCubit, SelectNetworkFeeState>(
                  builder: (context, state) {
                    return ListView.separated(
                      itemCount: state.networkFeeList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return SelectNetworkFeeItem(
                          networkFeeModel: state.networkFeeList[i],
                          isSelected: state.selectedNetworkFee ==
                              state.networkFeeList[i],
                          onPressed: () {
                            context
                                .read<SelectNetworkFeeCubit>()
                                .setSelectedNetworkFee(
                                  selectedNetworkFee: state.networkFeeList[i],
                                );
                            Navigator.pop(context);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.spaceSmall,
                        ),
                        child: Divider(
                          height: 0.2,
                          color: Theme.of(context).colorScheme.borderColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
