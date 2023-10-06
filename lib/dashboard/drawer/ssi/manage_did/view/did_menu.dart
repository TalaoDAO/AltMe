import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DidMenu extends StatelessWidget {
  const DidMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ssiMenu/didMenu'),
      builder: (_) => const DidMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DidView();
  }
}

class DidView extends StatelessWidget {
  const DidView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.drawerBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BackLeadingButton(
                  padding: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const Center(
                  child: AltMeLogo(size: 90),
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                DrawerItem(
                  title: l10n.manageKeyDecentralizedIdEdSA,
                  onTap: () {
                    Navigator.of(context)
                        .push<void>(ManageDIDEdDSAPage.route());
                  },
                ),
                DrawerItem(
                  title: l10n.manageKeyDecentralizedIDSecp256k1,
                  onTap: () {
                    Navigator.of(context)
                        .push<void>(ManageDidSecp256k1Page.route());
                  },
                ),
                DrawerItem(
                  title: l10n.manageEbsiV3DecentralizedId,
                  onTap: () {
                    Navigator.of(context)
                        .push<void>(ManageDidEbsiV3Page.route());
                  },
                ),
                DrawerItem(
                  title: l10n.polygonDecentralizedID,
                  onTap: () async {
                    LoadingView().show(context: context);
                    try {
                      final polygonIdCubit = context.read<PolygonIdCubit>();
                      await polygonIdCubit.initialise();
                      LoadingView().hide();
                      await Navigator.of(context)
                          .push<void>(ManageDidPolygonIdPage.route());
                    } catch (e) {
                      LoadingView().hide();
                      AlertMessage.showStateMessage(
                        context: context,
                        stateMessage: StateMessage.error(
                          showDialog: true,
                          //stringMessage: e.toString(),
                          messageHandler: ResponseMessage(
                            message: ResponseString
                                .RESPONSE_STRING_deviceIncompatibilityMessage,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
