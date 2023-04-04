import 'package:altme/app/app.dart';
import 'package:altme/dashboard/discover/cubit/discover_tabbar_cubit.dart';
import 'package:altme/dashboard/home/tab_bar/tab_bar.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverTabbarCubit(),
      child: const DiscoverPageView(),
    );
  }
}

class DiscoverPageView extends StatefulWidget {
  const DiscoverPageView({super.key});

  @override
  State<DiscoverPageView> createState() => _DiscoverPageViewState();
}

class _DiscoverPageViewState extends State<DiscoverPageView>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(vsync: this, length: 3);

  Future<void> onRefresh() async {}

  @override
  void initState() {
    context.read<CredentialListCubit>().initialise(context.read<WalletCubit>());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocConsumer<CredentialListCubit, CredentialListState>(
        listener: (context, state) {
          if (state.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null &&
              state.status != AppStatus.errorWhileFetching) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }

          if (state.status == AppStatus.success) {
            //some action
          }
        },
        builder: (context, state) {
          final CredentialListCubit credentialListCubit =
              context.read<CredentialListCubit>();

          return BlocBuilder<DiscoverTabbarCubit, int>(
            builder: (context, tabState) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Theme(
                    data: ThemeData(),
                    child: TabBar(
                      controller: _tabController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.space2XSmall,
                      ),
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: Sizes.space2XSmall,
                      ),
                      indicatorWeight: 0.0000001,
                      indicator: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.zero,
                        border: Border.all(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        MyTab(
                          text: l10n.cards,
                          icon: tabState == 0
                              ? IconStrings.cards
                              : IconStrings.cardsBlur,
                          isSelected: tabState == 0,
                          onPressed: () {
                            _tabController.animateTo(0);
                            context.read<DiscoverTabbarCubit>().setIndex(0);
                          },
                        ),
                        MyTab(
                          text: l10n.nfts,
                          icon: tabState == 1
                              ? IconStrings.ghost
                              : IconStrings.ghostBlur,
                          isSelected: tabState == 1,
                          onPressed: () {
                            _tabController.animateTo(1);
                            context.read<DiscoverTabbarCubit>().setIndex(1);
                          },
                        ),
                        MyTab(
                          text: l10n.coins,
                          icon: tabState == 2
                              ? IconStrings.health
                              : IconStrings.healthBlur,
                          isSelected: tabState == 2,
                          onPressed: () {
                            _tabController.animateTo(2);
                            context.read<DiscoverTabbarCubit>().setIndex(2);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceNormal),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        DiscoverCredentialList(
                          onRefresh: () async {
                            await context
                                .read<CredentialListCubit>()
                                .initialise(context.read<WalletCubit>());
                          },
                          state: state.populate(
                            gamingCredentials:
                                credentialListCubit.dummyListFromCategory(
                              state.gamingCategories,
                            ),
                            communityCredentials:
                                credentialListCubit.dummyListFromCategory(
                              state.communityCategories,
                            ),
                            identityCredentials:
                                credentialListCubit.dummyListFromCategory(
                              state.identityCategories,
                            ),
                            myProfessionalCredentials:
                                credentialListCubit.dummyListFromCategory(
                              state.myProfessionalCategories,
                            ),
                            blockchainAccountsCredentials: [],
                            educationCredentials: [],
                            othersCredentials: [],
                          ),
                        ),
                        //MWebViewPage(url: 'https://google.com'),
                        Center(
                          child: Text(l10n.thisFeatureIsNotSupportedMessage),
                        ),
                        Center(
                          child: Text(l10n.thisFeatureIsNotSupportedMessage),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
