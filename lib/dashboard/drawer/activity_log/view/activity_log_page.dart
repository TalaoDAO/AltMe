import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ActivityLogPage(),
      settings: const RouteSettings(name: '/ActivityLogPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityLogCubit(
        activityLogManager: ActivityLogManager(getSecureStorage),
      ),
      child: const ActivityLogView(),
    );
  }
}

class ActivityLogView extends StatefulWidget {
  const ActivityLogView({super.key});

  @override
  State<ActivityLogView> createState() => _ActivityLogViewState();
}

class _ActivityLogViewState extends State<ActivityLogView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await context.read<ActivityLogCubit>().getAllLogs();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<ActivityLogCubit, ActivityLogState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }
      },
      builder: (context, state) {
        return BasePage(
          scrollView: false,
          title: l10n.activityLog,
          titleAlignment: Alignment.topCenter,
          titleLeading: const BackLeadingButton(),
          body: ListView.builder(
            itemCount: state.logDatas.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              final LogData logData = state.logDatas[index];

              var message = '';

              switch (logData.type) {
                case LogType.walletInit:
                  message = 'Wallet Initialized';
                case LogType.backupData:
                  message = 'Backup Credentials';
                case LogType.restoreWallet:
                  message = 'Restored Credentials';
                case LogType.addVC:
                  message = 'Added credential ${logData.data}';
                case LogType.deleteVC:
                  message = 'Deleted credential ${logData.data}';
                case LogType.presentVC:
                  message = 'Presented credential ${logData.data}';
                case LogType.importKey:
                  message = 'Keys imported';
              }

              return Column(
                children: [
                  BackgroundCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              logData.timestamp.toString(),
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.333,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            message,
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
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
