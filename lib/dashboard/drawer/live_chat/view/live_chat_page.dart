import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix/matrix.dart';

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
    return BlocProvider<LiveChatCubit>(
      create: (_) => LiveChatCubit(
        client: Client(
          context.read<WalletCubit>().state.currentAccount?.walletAddress ??
              'unknown',
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
            return const Center(
              child: Text('logged in!'),
            );
          }
        },
      ),
    );
  }
}
