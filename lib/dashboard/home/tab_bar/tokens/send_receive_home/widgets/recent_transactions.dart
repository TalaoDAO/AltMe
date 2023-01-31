import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    this.operations = const [],
    required this.decimal,
    required this.symbol,
    this.tokenUsdPrice,
    required this.onRefresh,
  });

  final List<OperationModel> operations;
  final int decimal;
  final String symbol;
  final double? tokenUsdPrice;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: BackgroundCard(
        color: Theme.of(context).colorScheme.cardBackground,
        margin: const EdgeInsets.all(Sizes.spaceSmall),
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              l10n.recentTransactions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            Expanded(
              child: operations.isEmpty
                  ? Container()
                  : RefreshIndicator(
                      onRefresh: onRefresh,
                      child: ListView.separated(
                        itemBuilder: (_, index) => TransactionItem(
                          operationModel: operations[index],
                          symbol: symbol,
                          decimal: decimal,
                          tokenUsdPrice: tokenUsdPrice,
                          onTap: () {
                            final network = context
                                .read<ManageNetworkCubit>()
                                .state
                                .network;
                            openBlockchainExplorer(
                              network,
                              operations[index].hash,
                            );
                          },
                        ),
                        separatorBuilder: (_, __) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Sizes.spaceSmall,
                            ),
                            child: Divider(
                              height: 0.2,
                              color: Theme.of(context).colorScheme.borderColor,
                            ),
                          );
                        },
                        itemCount: operations.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
