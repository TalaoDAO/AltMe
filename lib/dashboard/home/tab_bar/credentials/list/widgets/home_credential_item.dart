import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class HomeCredentialItem extends StatelessWidget {
  const HomeCredentialItem({
    super.key,
    required this.homeCredential,
    required this.fromDiscover,
  });

  final HomeCredential homeCredential;
  final bool fromDiscover;

  @override
  Widget build(BuildContext context) {
    return homeCredential.isDummy
        ? DummyCredentialItem(
            homeCredential: homeCredential,
            fromDiscover: fromDiscover,
          )
        : RealCredentialItem(credentialModel: homeCredential.credentialModel!);
  }
}

class RealCredentialItem extends StatelessWidget {
  const RealCredentialItem({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    if (credentialModel.data['credentialSubject']?['chatSupport'] != null) {
      final cardName = credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType.name;

      final cardChatSupportCubit = CardChatSupportCubit(
        secureStorageProvider: getSecureStorage,
        matrixChat: MatrixChatImpl(),
        invites: [
          credentialModel.data['credentialSubject']?['chatSupport'] as String
        ],
        storageKey: '$cardName-${SecureStorageKeys.cardChatSupportRoomId}',
        roomNamePrefix: cardName,
      );

      return BlocProvider(
        create: (_) => cardChatSupportCubit,
        child: StreamBuilder(
          stream: cardChatSupportCubit.unreadMessageCountStream,
          builder: (_, snapShot) {
            return CredentialsListPageItem(
              credentialModel: credentialModel,
              badgeCount: snapShot.data ?? 0,
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
        onTap: () {
          Navigator.of(context).push<void>(
            CredentialsDetailsPage.route(credentialModel: credentialModel),
          );
        },
      );
    }
  }
}

class DummyCredentialItem extends StatelessWidget {
  const DummyCredentialItem({
    super.key,
    required this.homeCredential,
    required this.fromDiscover,
  });

  final HomeCredential homeCredential;
  final bool fromDiscover;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      onTap: () async {
        if (context.read<HomeCubit>().state.homeStatus ==
            HomeStatus.hasNoWallet) {
          await showDialog<void>(
            context: context,
            builder: (_) => const WalletDialog(),
          );
          return;
        }

        await Navigator.push<void>(
          context,
          DiscoverDetailsPage.route(
            homeCredential: homeCredential,
            buttonText: l10n.getThisCard,
            onCallBack: () async {
              await discoverCredential(
                homeCredential: homeCredential,
                context: context,
              );
              Navigator.pop(context);
            },
          ),
        );
      },
      child: CredentialImage(image: homeCredential.image!),
    );
  }
}
