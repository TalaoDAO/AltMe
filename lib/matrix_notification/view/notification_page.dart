import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart'
    hide ImageMessage, Message;
import 'package:visibility_detector/visibility_detector.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const NotificationPage(),
      settings: const RouteSettings(name: '/NotificationPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const NotificationView<MatrixNotificationCubit>();
  }
}

class NotificationView<B extends ChatRoomCubit> extends StatefulWidget {
  const NotificationView({
    super.key,
  });

  @override
  _NotificationViewState<B> createState() => _NotificationViewState();
}

class _NotificationViewState<B extends ChatRoomCubit>
    extends State<NotificationView> {
  B? liveChatCubit;

  bool pageIsVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        liveChatCubit = context.read<B>();

        await context.read<MatrixNotificationCubit>().init();
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
      title: 'Test Notification',
      scrollView: false,
      titleLeading: const BackLeadingButton(),
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
                    disableImageGallery: true,
                    onSendPressed: (partialText) {},
                    onPreviewDataFetched:
                        liveChatCubit!.handlePreviewDataFetched,
                    user: state.user ?? const User(id: ''),
                    customBottomWidget: Container(),
                  ),
                  if (state.messages.isEmpty)
                    BackgroundCard(
                      padding: const EdgeInsets.all(Sizes.spaceSmall),
                      margin: const EdgeInsets.all(Sizes.spaceNormal),
                      child: Center(
                        child: Text(
                          'Test: Notification is empty',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
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
}
