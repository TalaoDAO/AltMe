import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    this.hideAppBar = true,
  });

  final bool hideAppBar;

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const SearchPage(
        hideAppBar: false,
      ),
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
      child: SearchView(
        hideAppBar: hideAppBar,
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({
    super.key,
    this.hideAppBar = false,
  });

  final bool hideAppBar;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return BasePage(
          title: hideAppBar ? null : l10n.searchCredentials,
          titleLeading: hideAppBar ? null : const BackLeadingButton(),
          titleAlignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollView: false,
          body: BackgroundCard(
            child: Column(
              children: [
                const Search(),
                const SizedBox(height: 15),
                if (state.status == AppStatus.loading)
                  const Expanded(child: SearchListShimmer())
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.credentials.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: CredentialsListPageItem(
                            credentialModel: state.credentials[index],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
