import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide Message, FileMessage;
import 'package:matrix/matrix.dart' hide User;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

class LiveChatPage extends StatelessWidget {
  const LiveChatPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LiveChatPage(),
      settings: const RouteSettings(name: '/liveChatPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientId =
        context.read<WalletCubit>().state.currentAccount?.walletAddress ??
            const Uuid().v4();
    return BlocProvider<LiveChatCubit>(
      create: (_) => LiveChatCubit(
        secureStorageProvider: getSecureStorage,
        user: User(id: clientId),
        client: Client(
          clientId,
        ),
      ),
      child: const LiveChatView(),
    );
  }
}

class LiveChatView extends StatefulWidget {
  const LiveChatView({super.key});

  @override
  State<LiveChatView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<LiveChatView> {
  late final LiveChatCubit liveChatCubit;
  @override
  void initState() {
    liveChatCubit = context.read<LiveChatCubit>();
    Future.microtask(liveChatCubit.init);
    super.initState();
  }

  @override
  void dispose() {
    liveChatCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.altmeSupport,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      body: BlocBuilder<LiveChatCubit, LiveChatState>(
        builder: (context, state) {
          if (state.status == AppStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == AppStatus.error) {
            return Center(
              child: Text(l10n.somethingsWentWrongTryAgainLater),
            );
          } else {
            return Chat(
              theme: const DarkChatTheme(),
              messages: state.messages,
              onSendPressed: liveChatCubit.onSendPressed,
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: liveChatCubit.handlePreviewDataFetched,
              user: state.user,
            );
          }
        },
      ),
    );
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  liveChatCubit.handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  liveChatCubit.handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleMessageTap(BuildContext _, Message message) async {
    await liveChatCubit.handleMessageTap(message);
  }
}
