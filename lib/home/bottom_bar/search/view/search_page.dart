import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const SearchPage(),
        settings: const RouteSettings(name: '/searchPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.search,
      titleLeading: const BackLeadingButton(),
      padding: EdgeInsets.zero,
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          var _credentialList = <CredentialModel>[];
          _credentialList = state.credentials;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BackgroundCard(
              child: Column(
                children: [
                  const Search(),
                  const SizedBox(height: 8),
                  ...List.generate(
                    _credentialList.length,
                    (index) => CredentialsListPageItem(
                      credentialModel: _credentialList[index],
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
