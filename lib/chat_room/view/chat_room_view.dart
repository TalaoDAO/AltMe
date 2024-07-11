import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide Message;
import 'package:visibility_detector/visibility_detector.dart';

class ChatRoomView<B extends ChatRoomCubit> extends StatefulWidget {
  const ChatRoomView({
    super.key,
    this.appBarTitle,
    this.chatWelcomeMessage,
  });

  final String? appBarTitle;
  final String? chatWelcomeMessage;

  @override
  _ChatRoomViewState<B> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState<B extends ChatRoomCubit> extends State<ChatRoomView> {
  B? liveChatCubit;

  bool pageIsVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        liveChatCubit = context.read<B>();

        await context.read<AltmeChatSupportCubit>().init();

        /// we are on same screen, it is considered as read
        context.read<AltmeChatSupportCubit>().hardCodeAllMessageAsRead();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return BasePage(
      title: widget.appBarTitle,
      scrollView: false,
      titleLeading:
          widget.appBarTitle == null ? null : const BackLeadingButton(),
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      body: BlocBuilder<B, ChatRoomState>(
        builder: (context, ChatRoomState state) {
          if (state.status == AppStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == AppStatus.error) {
            String message = '';
            if (state.message != null) {
              if (state.message!.stringMessage != null) {
                message = state.message!.stringMessage!;
              } else if (state.message!.messageHandler != null) {
                final MessageHandler messageHandler =
                    state.message!.messageHandler!;
                message = messageHandler.getMessage(context, messageHandler);
              }
            }
            return Center(
              child: ErrorView(
                message: message,
                onTap: liveChatCubit!.init,
              ),
            );
          } else {
            if (liveChatCubit == null) {
              return Container();
            }
            if (pageIsVisible) {
              liveChatCubit!.setMessagesAsRead();
            }
            return VisibilityDetector(
              key: const Key('chat-widget'),
              onVisibilityChanged: (visibilityInfo) {
                if (visibilityInfo.visibleFraction == 1.0) {
                  liveChatCubit!.setMessagesAsRead();
                  pageIsVisible = true;
                } else {
                  FocusManager.instance.primaryFocus?.unfocus();
                  pageIsVisible = false;
                }
              },
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Chat(
                    theme: DefaultChatTheme(
                      primaryColor: colorScheme.primaryContainer,
                      secondaryColor: colorScheme.secondaryContainer,
                      backgroundColor: colorScheme.surface,
                      inputBackgroundColor: colorScheme.secondaryContainer,
                      inputTextColor: colorScheme.onSurface,
                      errorColor: colorScheme.error,
                      sentMessageBodyTextStyle: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      sentMessageBodyBoldTextStyle: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.333,
                      ),
                      sentMessageDocumentIconColor: colorScheme.onPrimary,
                      sentMessageLinkTitleTextStyle: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.375,
                      ),
                      sentMessageCaptionTextStyle: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                      systemMessageTheme: SystemMessageTheme(
                        margin: const EdgeInsets.only(
                          bottom: 24,
                          top: 8,
                          left: 8,
                          right: 8,
                        ),
                        textStyle: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1.333,
                        ),
                      ),
                      receivedMessageBodyTextStyle: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      receivedMessageCaptionTextStyle: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.333,
                      ),
                      receivedMessageDocumentIconColor: colorScheme.onSurface,
                      receivedMessageLinkDescriptionTextStyle: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.428,
                      ),
                      receivedMessageLinkTitleTextStyle: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.375,
                      ),
                    ),
                    messages: state.messages,
                    // imageMessageBuilder: (p0, {required messageWidth}) =>
                    //     Text('Uri: ${p0.uri}'),
                    onSendPressed: (partialText) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      liveChatCubit!.onSendPressed(partialText);
                    },
                    onAttachmentPressed: _handleAttachmentPressed,
                    onMessageTap: _handleMessageTap,
                    onPreviewDataFetched:
                        liveChatCubit!.handlePreviewDataFetched,
                    user: state.user ?? const User(id: ''),
                  ),
                  if (state.messages.isEmpty)
                    BackgroundCard(
                      padding: const EdgeInsets.all(Sizes.spaceSmall),
                      margin: const EdgeInsets.all(Sizes.spaceNormal),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.chatWelcomeMessage ??
                                l10n.supportChatWelcomeMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: Sizes.spaceSmall,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lock,
                                size: Sizes.icon,
                              ),
                              const SizedBox(
                                width: Sizes.space2XSmall,
                              ),
                              Flexible(
                                child: MyText(
                                  l10n.e2eEncyptedChat,
                                  maxLines: 1,
                                  minFontSize: 8,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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
                  liveChatCubit!.handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  liveChatCubit!.handleFileSelection();
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
    await liveChatCubit!.handleMessageTap(message);
  }
}
