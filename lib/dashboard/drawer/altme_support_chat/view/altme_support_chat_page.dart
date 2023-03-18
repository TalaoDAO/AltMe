import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class AltmeSupportChatPage extends StatelessWidget {
  const AltmeSupportChatPage({
    super.key,
    this.appBarTitle,
  });

  final String? appBarTitle;

  static Route<void> route({String? appBarTitle}) {
    return MaterialPageRoute<void>(
      builder: (_) => AltmeSupportChatPage(
        appBarTitle: appBarTitle,
      ),
      settings: const RouteSettings(name: '/altmeSupportChatPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatRoomView<AltmeChatSupportCubit>(
      appBarTitle: appBarTitle,
    );
  }
}
