import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;

class ProtocolTraceLogsPage extends StatelessWidget {
  const ProtocolTraceLogsPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ProtocolTraceLogsPage(),
      settings: const RouteSettings(name: '/ProtocolTraceLogsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProtocolTraceLogsCubit(),
      child: const ProtocolTraceLogsView(),
    );
  }
}

class ProtocolTraceLogsView extends StatefulWidget {
  const ProtocolTraceLogsView({super.key});

  @override
  State<ProtocolTraceLogsView> createState() => _ProtocolTraceLogsViewState();
}

class _ProtocolTraceLogsViewState extends State<ProtocolTraceLogsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProtocolTraceLogsCubit>().getAllLogs();
    });
  }

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final l10n = context.l10n;
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return ConfirmDialog(
              title: l10n.deleteAllTraceLogsConfirmationTitle,
              subtitle: l10n.deleteAllTraceLogsConfirmationSubtitle,
            );
          },
        ) ??
        false;

    if (confirm && context.mounted) {
      await context.read<ProtocolTraceLogsCubit>().deleteAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ProtocolTraceLogsCubit, ProtocolTraceLogsState>(
      builder: (context, state) {
        final filePaths = state.filePaths;
        return BasePage(
          scrollView: false,
          titleAlignment: Alignment.topCenter,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackLeadingButton(padding: EdgeInsets.zero),
              const DrawerLogo(),
              const AppVersionDrawer(),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.protocolTraceLogs,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Expanded(
                child: filePaths.isEmpty
                    ? Center(
                        child: Text(
                          l10n.protocolTraceLogsEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filePaths.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final path = filePaths[index];
                          final file = File(path);
                          DateTime? lastModified;
                          try {
                            lastModified = file.lastModifiedSync();
                          } on FileSystemException {
                            lastModified = null;
                          }

                          return Column(
                            children: [
                              InkWell(
                                onTap: () => OpenFile.open(path),
                                child: BackgroundCard(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.basename(path),
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                              ),
                                            ),
                                            if (lastModified != null) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                UiDate.formatDatetime(
                                                  lastModified,
                                                ),
                                                style: TextStyle(
                                                  color: colorScheme.onSurface,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.333,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: Sizes.icon2x,
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.6,
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
              ),
            ],
          ),
          navigation: filePaths.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.all(Sizes.spaceSmall),
                  child: MyElevatedButton(
                    text: l10n.deleteAllTraceLogs,
                    backgroundColor: colorScheme.error,
                    onPressed: () => _confirmDeleteAll(context),
                  ),
                ),
        );
      },
    );
  }
}
