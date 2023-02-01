import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matrix/matrix.dart';

part 'live_chat_state.dart';
part 'live_chat_cubit.g.dart';

class LiveChatCubit extends Cubit<LiveChatState> {
  LiveChatCubit({
    required this.client,
  }) : super(
          const LiveChatState(),
        );

  final Client client;
  final logger = getLogger('LiveChatCubit');
  String _roomId = '';
  StreamSubscription<Event>? _onEventSubscription;
  final List<ChatMessageModel> messages = [];

  Future<void> sendMessage({required String message}) async {
    await client.getRoomById(_roomId)?.sendTextEvent(message);
  }

  Future<void> init() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      await _initClient();
      await _login();
      _roomId = await _createRoomAndInviteSupport();
      _subscribeToEventsOfRoom();
      emit(state.copyWith(status: AppStatus.init));
    } catch (e, s) {
      logger.e('error: $e, stack: $s');
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  void _subscribeToEventsOfRoom() {
    _onEventSubscription?.cancel();
    _onEventSubscription = client.onRoomState.stream.listen((Event event) {
      if (event.roomId == _roomId) {
        messages.add(
          ChatMessageModel(
            senderId: event.senderId,
            roomId: _roomId,
            dateTime: DateTime.now(),
            body: event.body,
          ),
        );
      }
    });
  }

  Future<String> _createRoomAndInviteSupport() async {
    return client.createRoom(
      isDirect: true,
      invite: ['altme-support'], // TODO(Taleb): update id of support
      name: 'support',
      roomAliasName: 'support',
    );
  }

  Future<void> _initClient() async {
    await dotenv.load();
    final homeServer = dotenv.get('MATRIX_HOME_SERVER');
    client.homeserver = Uri.parse(homeServer);
    await client.init();
  }

  Future<void> _login() async {
    final username = dotenv.get('MATRIX_USERNAME');
    final password = dotenv.get('MATRIX_PASSWORD');
    await client.login(
      LoginType.mLoginPassword,
      password: password,
      identifier: AuthenticationUserIdentifier(user: username),
    );
  }

  Future<void> dispose() async {
    await client.logout();
    await _onEventSubscription?.cancel();
  }
}
