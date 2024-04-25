import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
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
    context.read<CredentialsCubit>().loadAllCredentials(
          blockchainType:
              context.read<WalletCubit>().state.currentAccount!.blockchainType,
        );
    super.initState();
  }

  Future<void> onRefresh() async {
    await context.read<CredentialsCubit>().loadAllCredentials(
          blockchainType:
              context.read<WalletCubit>().state.currentAccount!.blockchainType,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) {
          if (current.model.profileSetting.selfSovereignIdentityOptions
                  .customOidc4vcProfile.vcFormatType !=
              previous.model.profileSetting.selfSovereignIdentityOptions
                  .customOidc4vcProfile.vcFormatType) {
            return true;
          }

          if (current.model.isDeveloperMode != previous.model.isDeveloperMode) {
            return true;
          }

          return false;
        },
        listener: (context, state) {
          onRefresh();
        },
        child: BlocBuilder<CredentialsCubit, CredentialsState>(
          builder: (context, state) {
            String message = '';
            if (state.message != null) {
              final MessageHandler messageHandler =
                  state.message!.messageHandler!;
              message = messageHandler.getMessage(context, messageHandler);
            }

            if (state.status == CredentialsStatus.loading) {
              return const CredentialListShimmer();
            } else if (state.status == CredentialsStatus.error) {
              return ErrorView(message: message, onTap: onRefresh);
            } else {
              return HomeCredentialCategoryList(
                credentials: state.credentials,
                onRefresh: onRefresh,
              );
            }
          },
        ),
      ),
    );
  }
}
