import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/list/widgets/credential_list_data.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsListPage extends StatefulWidget {
  const CredentialsListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CredentialsListPage> createState() => _CredentialsListPageState();
}

class _CredentialsListPageState extends State<CredentialsListPage>
    with AutomaticKeepAliveClientMixin<CredentialsListPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    context.read<CredentialListCubit>().initialise(context.read<WalletCubit>());
    super.initState();
  }

  Future<void> onRefresh() async {
    await context
        .read<CredentialListCubit>()
        .initialise(context.read<WalletCubit>());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
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
          String message = '';
          if (state.message != null) {
            final MessageHandler messageHandler =
                state.message!.messageHandler!;
            message = messageHandler.getMessage(context, messageHandler);
          }

          if (state.status == AppStatus.fetching) {
            return const CredentialListShimmer();
          } else if (state.status == AppStatus.populate) {
            return CredentialListData(state: state, onRefresh: onRefresh);
          } else if (state.status == AppStatus.errorWhileFetching) {
            return ErrorView(message: message, onTap: onRefresh);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
