import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => SearchCubit(
            secureStorageProvider: secure_storage.getSecureStorage,
            repository: CredentialsRepository(secure_storage.getSecureStorage),
          ),
          child: const SearchPage(),
        ),
        settings: const RouteSettings(name: '/searchPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.search,
      titleLeading: const BackLeadingButton(),
      padding: EdgeInsets.zero,
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          var _credentialList = <CredentialModel>[];
          _credentialList = state.credentials;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BackgroundCard(
              child: Column(
                children: [
                  const Search(),
                  const SizedBox(height: 10),
                  ...List.generate(
                    _credentialList.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: CredentialsListPageItem(
                        credentialModel: _credentialList[index],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
