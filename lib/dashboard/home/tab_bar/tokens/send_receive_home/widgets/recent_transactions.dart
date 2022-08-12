import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({Key? key}) : super(key: key);

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(Sizes.spaceSmall),
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(Sizes.normalRadius),
          ),
          color: Theme.of(context).hoverColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              l10n.recentTransactions,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: Sizes.spaceNormal,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => Container(
                  height: 20,
                ),
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
