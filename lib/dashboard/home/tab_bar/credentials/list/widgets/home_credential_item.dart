import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class HomeCredentialItem extends StatelessWidget {
  const HomeCredentialItem({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    if (credentialModel.data['credentialSubject']?['chatSupport'] != null) {
      final cardChatSupportCubit = CardChatSupportCubit(
        secureStorageProvider: getSecureStorage,
        matrixChat: MatrixChatImpl(),
        profileCubit: context.read<ProfileCubit>(),
        roomIdStoredKey: 'putIdHereIfNeededInFuture',
      );

      return BlocProvider(
        create: (_) => cardChatSupportCubit,
        child: StreamBuilder(
          stream: cardChatSupportCubit.unreadMessageCountStream,
          initialData: cardChatSupportCubit.unreadMessageCount,
          builder: (context, snapShot) {
            return CredentialsListPageItem(
              credentialModel: credentialModel,
              badgeCount: snapShot.data ?? 0,
              isDiscover: false,
              onTap: () {
                Navigator.of(context).push<void>(
                  CredentialsDetailsPage.route(
                    credentialModel: credentialModel,
                    cardChatSupportCubit: cardChatSupportCubit,
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return CredentialsListPageItem(
        credentialModel: credentialModel,
        isDiscover: false,
        onTap: () {
          Navigator.of(context).push<void>(
            CredentialsDetailsPage.route(credentialModel: credentialModel),
          );
        },
      );
    }
  }
}
