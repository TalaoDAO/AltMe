import 'package:altme/app/shared/alert_message/alert_message.dart';
import 'package:altme/app/shared/enum/status/app_status.dart';
import 'package:altme/app/shared/loading/loading_view.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/home/tab_bar/tab_bar.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Future<void> onRefresh() async {}

  @override
  void initState() {
    context.read<CredentialListCubit>().initialise(context.read<WalletCubit>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scrollView: false,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocConsumer<CredentialListCubit, CredentialListState>(
        listener: (context, state) {
          if (state.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null &&
              state.status != AppStatus.errorWhileFetching) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }

          if (state.status == AppStatus.success) {
            //some action
          }
        },
        builder: (context, state) {
          final CredentialListCubit credentialListCubit =
              context.read<CredentialListCubit>();

          return DiscoverCredentialList(
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
              myProfessionalCredentials:
                  credentialListCubit.dummyListFromCategory(
                state.myProfessionalCategories,
              ),
              blockchainAccountsCredentials: [],
              educationCredentials: [],
              othersCredentials: [],
            ),
          );
        },
      ),
    );
  }
}
