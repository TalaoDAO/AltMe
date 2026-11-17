import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_ui/wallet_ui.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _clear() async {
    final cubit = context.read<SearchCubit>();
    searchController.clear();
    focusNode.unfocus();
    await cubit.searchWallet('');
    await cubit.loadAllCredentialsFromRepository();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) =>
          previous.searchText.isEmpty != current.searchText.isEmpty,
      builder: (context, state) {
        return WalletTextField(
          label: l10n.search,
          controller: searchController,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          onChanged: context.read<SearchCubit>().searchWallet,
          prefix: const WalletIcon(WalletIconStrings.search),
          suffix: state.searchText.isEmpty
              ? null
              : IconButton(
                  tooltip: l10n.clearSearch,
                  icon: const WalletIcon(WalletIconStrings.closeSmall),
                  onPressed: _clear,
                ),
        );
      },
    );
  }
}
