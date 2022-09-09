import 'package:altme/app/shared/widget/base/page.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/list/widgets/credential_list_data.dart';
import 'package:altme/dashboard/home/tab_bar/tab_bar.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  Future<void> onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocBuilder<CredentialListCubit, CredentialListState>(
        builder: (context, state) {
          final CredentialListCubit credentialListCubit =
              context.read<CredentialListCubit>();
          return CredentialListData(
            onRefresh: () async {
              await context
                  .read<CredentialListCubit>()
                  .initialise(context.read<WalletCubit>());
            },
            state: state.populate(
              gamingCredentials: credentialListCubit.dummyListFromCategory(
                state.gamingCategories,
              ),
              communityCredentials: credentialListCubit.dummyListFromCategory(
                state.communityCategories,
              ),
              identityCredentials: credentialListCubit.dummyListFromCategory(
                state.identityCategories,
              ),
              proofOfOwnershipCredentials: [],
              othersCredentials: [],
            ),
          );
        },
      ),
    );
  }
}
