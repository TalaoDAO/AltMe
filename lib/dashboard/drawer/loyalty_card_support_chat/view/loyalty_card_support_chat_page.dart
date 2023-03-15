import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class LoyaltyCardSupportChatPage extends StatelessWidget {
  const LoyaltyCardSupportChatPage({
    super.key,
    this.appBarTitle,
    this.chatWelcomeMessage,
    required this.companySupportId,
    required this.loyaltyCardType,
  });

  final String? appBarTitle;
  final String? chatWelcomeMessage;
  final String companySupportId;
  final String loyaltyCardType;

  static Route<void> route({
    String? appBarTitle,
    String? chatWelcomeMessage,
    required String companySupportId,
    required String loyaltyCardType,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => LoyaltyCardSupportChatPage(
        appBarTitle: appBarTitle,
        companySupportId: companySupportId,
        loyaltyCardType: loyaltyCardType,
        chatWelcomeMessage: chatWelcomeMessage,
      ),
      settings: const RouteSettings(name: '/loyaltyCardSupportChatPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoyaltyCardSupportChatCubit(
        secureStorageProvider: getSecureStorage,
        matrixChat: MatrixChatImpl(),
        invites: [companySupportId],
        storageKey:
            '$loyaltyCardType-${SecureStorageKeys.loyaltyCardsupportRoomId}',
        roomNamePrefix: loyaltyCardType,
      ),
      child: ChatRoomView<LoyaltyCardSupportChatCubit>(
        appBarTitle: appBarTitle,
        chatWelcomeMessage: chatWelcomeMessage,
      ),
    );
  }
}
