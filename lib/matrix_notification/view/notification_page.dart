import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/matrix_notification/matrix_notification.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

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
        liveChatCubit!.setMessagesAsRead();
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
      title: l10n.notifications,
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

            return Column(
              children: [
                if (state.messages.isEmpty)
                  BackgroundCard(
                    padding: const EdgeInsets.all(Sizes.spaceSmall),
                    margin: const EdgeInsets.all(Sizes.spaceNormal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.notificationTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    l10n.notificationTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: Sizes.spaceLarge),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: state.messages.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Message message = state.messages[index];
                          final map = message.toJson();

                          final String text = map['text'].toString();

                          return Column(
                            children: [
                              TransparentInkWell(
                                onTap: () {
                                  context
                                      .read<MatrixNotificationCubit>()
                                      .markMessageAsRead([message.remoteId]);
                                  Navigator.of(context).push<void>(
                                    NotificationDetailsPage.route(
                                        message: text),
                                  );
                                },
                                child: BackgroundCard(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            chatTimeFormatter(
                                              message.createdAt ?? 0,
                                            ),
                                            style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              height: 1.333,
                                            ),
                                          ),
                                          if (message.status != null &&
                                              message.status !=
                                                  Status.seen) ...[
                                            const SizedBox(width: 10),
                                            const NotifyDot(),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          text,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      if (state.messages.isEmpty)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            l10n.noNotificationsYet,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
