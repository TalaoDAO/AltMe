import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCredentialsListPage extends StatefulWidget {
  const HomeCredentialsListPage({
    super.key,
  });

  @override
  State<HomeCredentialsListPage> createState() =>
      _HomeCredentialsListPageState();
}

class _HomeCredentialsListPageState extends State<HomeCredentialsListPage>
    with AutomaticKeepAliveClientMixin<HomeCredentialsListPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    context.read<CredentialsCubit>().loadAllCredentials();
    super.initState();
  }

  Future<void> onRefresh() async {
    await context.read<CredentialsCubit>().loadAllCredentials();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocConsumer<CredentialsCubit, CredentialsState>(
        listener: (context, state) {
          if (state.status == CredentialsStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null &&
              state.status != CredentialsStatus.error) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }

          if (state.status == CredentialsStatus.populate) {
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

          if (state.status == CredentialsStatus.loading) {
            return const CredentialListShimmer();
          } else if (state.status == CredentialsStatus.populate) {
            //return CredentialListData(state: state, onRefresh: onRefresh);
            return HomeCredentialCategoryList(
              credentials: state.credentials,
              onRefresh: onRefresh,
            );
          } else if (state.status == CredentialsStatus.error) {
            return ErrorView(message: message, onTap: onRefresh);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
