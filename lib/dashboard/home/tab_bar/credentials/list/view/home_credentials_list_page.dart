import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCredentialsListPage extends StatefulWidget {
  const HomeCredentialsListPage({super.key});

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
      padding: Parameters.walletHandlesCrypto
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(
              Sizes.spaceSmall,
              Sizes.spaceSmall,
              Sizes.spaceSmall,
              0,
            ),
      backgroundColor: Colors.transparent,
      body: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) {
          if (current
                  .model
                  .profileSetting
                  .selfSovereignIdentityOptions
                  .customOidc4vcProfile
                  .formatsSupported !=
              previous
                  .model
                  .profileSetting
                  .selfSovereignIdentityOptions
                  .customOidc4vcProfile
                  .formatsSupported) {
            print('profileCubit listener: ${current.status}');

            return true;
          }

          if (current.model.isDeveloperMode != previous.model.isDeveloperMode) {
            return true;
          }

          return false;
        },
        listener: (context, state) {
          if (state.status != AppStatus.idle) {
            onRefresh();
          }
        },
        child: BlocBuilder<CredentialsCubit, CredentialsState>(
          buildWhen: (previous, current) =>
              current.status != CredentialsStatus.idle,
          builder: (context, state) {
            print(state.status);
            String message = '';
            if (state.message != null) {
              final MessageHandler messageHandler =
                  state.message!.messageHandler!;
              message = messageHandler.getMessage(context, messageHandler);
            }

            if (state.status == CredentialsStatus.error) {
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
