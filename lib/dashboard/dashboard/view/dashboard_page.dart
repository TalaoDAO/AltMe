import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const DashboardPage(),
        settings: const RouteSettings(name: '/dashboardPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void bottomTapped(int index) {
    context.read<DashboardCubit>().onPageChanged(index);
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final l10n = context.l10n;
        return WillPopScope(
          onWillPop: () async => false,
          child: BasePage(
            scrollView: false,
            padding: EdgeInsets.zero,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        onPageChanged:
                            context.read<DashboardCubit>().onPageChanged,
                        children: [
                          const HomePage(),
                          Container(
                            color: Theme.of(context).colorScheme.background,
                            child: const Text('1'),
                          ),
                          Container(
                            color: Theme.of(context).colorScheme.background,
                            child: const Text('2'),
                          ),
                          const ProfilePage(),
                        ],
                      ),
                    ),
                    BottomBarDecoration(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BottomBarItem(
                            icon: IconStrings.story,
                            text: l10n.infos,
                            onTap: () => bottomTapped(0),
                            isSelected: state.selectedIndex == 0,
                          ),
                          BottomBarItem(
                            icon: IconStrings.profile,
                            text: l10n.profile,
                            onTap: () => bottomTapped(1),
                            isSelected: state.selectedIndex == 1,
                          ),
                          const SizedBox.shrink(),
                          const SizedBox.shrink(),
                          BottomBarItem(
                            icon: IconStrings.searchNormal,
                            text: l10n.search,
                            onTap: () => bottomTapped(2),
                            isSelected: state.selectedIndex == 2,
                          ),
                          BottomBarItem(
                            icon: IconStrings.save,
                            text: l10n.save,
                            onTap: () => bottomTapped(3),
                            isSelected: state.selectedIndex == 3,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: QRIcon(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
