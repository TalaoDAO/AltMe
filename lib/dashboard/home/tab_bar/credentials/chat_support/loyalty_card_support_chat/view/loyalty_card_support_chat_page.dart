import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoyaltyCardSupportChatPage extends StatelessWidget {
  const LoyaltyCardSupportChatPage({
    super.key,
    this.appBarTitle,
    this.chatWelcomeMessage,
    required this.loyaltyCardSupportChatCubit,
  });

  final String? appBarTitle;
  final String? chatWelcomeMessage;
  final LoyaltyCardSupportChatCubit loyaltyCardSupportChatCubit;

  static Route<void> route({
    String? appBarTitle,
    String? chatWelcomeMessage,
    required LoyaltyCardSupportChatCubit loyaltyCardSupportChatCubit,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => LoyaltyCardSupportChatPage(
        appBarTitle: appBarTitle,
        chatWelcomeMessage: chatWelcomeMessage,
        loyaltyCardSupportChatCubit: loyaltyCardSupportChatCubit,
      ),
      settings: const RouteSettings(name: '/loyaltyCardSupportChatPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: loyaltyCardSupportChatCubit,
      child: ChatRoomView<LoyaltyCardSupportChatCubit>(
        appBarTitle: appBarTitle,
        chatWelcomeMessage: chatWelcomeMessage,
      ),
    );
  }
}
