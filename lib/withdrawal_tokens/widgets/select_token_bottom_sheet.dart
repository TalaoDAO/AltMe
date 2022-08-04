import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/view/widgets/widgets.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectTokenBottomSheet extends StatelessWidget {
  const SelectTokenBottomSheet({Key? key}) : super(key: key);

  static Future<TokenModel?> show(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Sizes.largeRadius),
          topLeft: Radius.circular(Sizes.largeRadius),
        ),
      ),
      context: context,
      builder: (_) => const SelectTokenBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _SelectTokenBottomSheetView();
  }
}

class _SelectTokenBottomSheetView extends StatefulWidget {
  const _SelectTokenBottomSheetView({Key? key}) : super(key: key);

  @override
  State<_SelectTokenBottomSheetView> createState() =>
      _SelectTokenBottomSheetViewState();
}

class _SelectTokenBottomSheetViewState
    extends State<_SelectTokenBottomSheetView> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectToken,
                // TODO(Taleb): change the style
                style: Theme.of(context).textTheme.accountsText,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Expanded(
                child: TokenList(tokenList: [], onRefresh: () async {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
