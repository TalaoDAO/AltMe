import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide Message, FileMessage;

class LiveChatPage extends StatelessWidget {
  const LiveChatPage({
    super.key,
    this.hideAppBar = false,
  });

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LiveChatPage(
        hideAppBar: false,
      ),
      settings: const RouteSettings(name: '/liveChatPage'),
    );
  }

  final bool hideAppBar;

  @override
  Widget build(BuildContext context) {
    return LiveChatView(
      hideAppBar: hideAppBar,
    );
  }
}

class LiveChatView extends StatefulWidget {
  const LiveChatView({
    super.key,
    this.hideAppBar = false,
  });
  final bool hideAppBar;

  @override
  State<LiveChatView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<LiveChatView> {
  late final LiveChatCubit liveChatCubit;
  @override
  void initState() {
    liveChatCubit = context.read<LiveChatCubit>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: widget.hideAppBar ? null : l10n.altmeSupport,
      scrollView: false,
      titleLeading: widget.hideAppBar ? null : const BackLeadingButton(),
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
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Chat(
                  theme: const DarkChatTheme(),
                  messages: state.messages,
                  onSendPressed: liveChatCubit.onSendPressed,
                  onAttachmentPressed: _handleAttachmentPressed,
                  onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: liveChatCubit.handlePreviewDataFetched,
                  user: state.user ?? const User(id: ''),
                ),
                if (state.messages.isEmpty)
                  BackgroundCard(
                    padding: const EdgeInsets.all(Sizes.spaceNormal),
                    margin: const EdgeInsets.all(Sizes.spaceNormal),
                    child: Text(
                      l10n.supportChatWelcomeMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
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
