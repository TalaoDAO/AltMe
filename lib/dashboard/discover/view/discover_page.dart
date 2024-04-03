import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Future<void> onRefresh() async {
    await context.read<CredentialsCubit>().loadAllCredentials(
          blockchainType:
              context.read<WalletCubit>().state.currentAccount!.blockchainType,
        );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) {
          // if (current.model.profileSetting.selfSovereignIdentityOptions
          //         .customOidc4vcProfile.vcFormatType !=
          //     previous.model.profileSetting.selfSovereignIdentityOptions
          //         .customOidc4vcProfile.vcFormatType) {
          //   return true;
          // }

          return true;
        },
        listener: (context, state) {
          onRefresh();
        },
        child: BlocBuilder<CredentialsCubit, CredentialsState>(
          builder: (context, state) {
            return DiscoverCredentialCategoryList(
              onRefresh: onRefresh,
              dummyCredentials: state.dummyCredentials,
            );
          },
        ),
      ),
    );
  }
}
