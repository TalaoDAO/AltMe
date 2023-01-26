import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      searchController.addListener(() {
        context.read<SearchCubit>().searchWallet(searchController.text);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return BaseTextField(
          prefixIcon: state.searchText.isNotEmpty
              ? InkWell(
                  onTap: () async {
                    searchController.text = '';
                    focusNode.unfocus();
                    await context
                        .read<SearchCubit>()
                        .loadAllCredentialsFromRepository();
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : const SizedBox.shrink(),
          suffixIcon: const Icon(Icons.search),
          label: l10n.search,
          controller: searchController,
          focusNode: focusNode,
        );
      },
    );
  }
}
