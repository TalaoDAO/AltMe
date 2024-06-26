import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/drawer/help_center/altme_support_chat/cubit/altme_support_chat_cubit.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> resetWallet(BuildContext context) async {
  await context.read<ProfileCubit>().resetProfile();
  await context
      .read<WalletCubit>()
      .resetWallet(context.read<CredentialsCubit>());
  await context.read<AltmeChatSupportCubit>().dispose();
}
