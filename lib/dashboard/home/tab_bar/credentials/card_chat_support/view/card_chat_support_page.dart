import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoyaltyCardSupportChatPage extends StatelessWidget {
  const LoyaltyCardSupportChatPage({
    super.key,
    this.appBarTitle,
    this.chatWelcomeMessage,
    required this.cardChatSupportCubit,
  });

  final String? appBarTitle;
  final String? chatWelcomeMessage;
  final CardChatSupportCubit cardChatSupportCubit;

  static Route<void> route({
    String? appBarTitle,
    String? chatWelcomeMessage,
    required CardChatSupportCubit cardChatSupportCubit,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => LoyaltyCardSupportChatPage(
        appBarTitle: appBarTitle,
        chatWelcomeMessage: chatWelcomeMessage,
        cardChatSupportCubit: cardChatSupportCubit,
      ),
      settings: const RouteSettings(name: '/loyaltyCardSupportChatPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cardChatSupportCubit,
      child: ChatRoomView<CardChatSupportCubit>(
        appBarTitle: appBarTitle,
        chatWelcomeMessage: chatWelcomeMessage,
      ),
    );
  }
}
