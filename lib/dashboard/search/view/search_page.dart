import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;
import 'package:wallet_ui/wallet_ui.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, this.hideAppBar = true});

  final bool hideAppBar;

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const SearchPage(hideAppBar: false),
      settings: const RouteSettings(name: '/searchPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        secureStorageProvider: secure_storage.getSecureStorage,
        repository: CredentialsRepository(secure_storage.getSecureStorage),
      ),
      child: SearchView(hideAppBar: hideAppBar),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({super.key, this.hideAppBar = false});

  final bool hideAppBar;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final showEmpty =
            state.status != AppStatus.loading &&
            state.searchText.trim().isNotEmpty &&
            state.credentials.isEmpty;
        return BasePage(
          backgroundColor: context.walletColors.backgroundAlternative,
          appBarBackgroundColor: context.walletColors.backgroundAlternative,
          title: hideAppBar ? null : l10n.searchCredentials,
          titleLeading: hideAppBar ? null : const BackLeadingButton(),
          titleAlignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: WalletSpacing.m),
          scrollView: false,
          body: Column(
            children: [
              const Search(),
              const SizedBox(height: WalletSpacing.m),
              if (state.status == AppStatus.loading)
                const Expanded(child: SearchListShimmer())
              else if (showEmpty)
                Expanded(child: SearchEmptyView(query: state.searchText))
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: state.credentials.length,
                    physics: const ScrollPhysics(),
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: WalletSpacing.m),
                    itemBuilder: (context, index) {
                      return CredentialContainerCard(
                        credentialModel: state.credentials[index],
                        onTap: () {
                          Navigator.of(context).push<void>(
                            CredentialsDetailsPage.route(
                              credentialModel: state.credentials[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
