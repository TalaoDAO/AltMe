import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTokensPage extends StatelessWidget {
  const AllTokensPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/addTokensPage'),
      builder: (_) => const AllTokensPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _AllTokensView();
  }
}

class _AllTokensView extends StatefulWidget {
  const _AllTokensView({Key? key}) : super(key: key);

  @override
  State<_AllTokensView> createState() => _AllTokensViewState();
}

class _AllTokensViewState extends State<_AllTokensView> {
  @override
  void initState() {
    Future<void>.microtask(context.read<AllTokensCubit>().init);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AllTokensCubit, AllTokensState>(
      builder: (context, state) {
        getLogger('_AllTokensView')
            .i('list of selected contract: ${state.selectedContracts}');
        return BasePage(
          scrollView: false,
          padding: EdgeInsets.zero,
          titleLeading: const BackLeadingButton(),
          titleTrailing: const CryptoAccountSwitcherButton(),
          body: BackgroundCard(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            margin: const EdgeInsets.all(Sizes.spaceSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.addTokens,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextButton(
                      onPressed: (state.status == AppStatus.loading ||
                              state.status == AppStatus.fetching)
                          ? null
                          : () async {
                              await context
                                  .read<AllTokensCubit>()
                                  .saveSelectedContracts();
                              Navigator.of(context).pop();
                            },
                      child: Text(
                        l10n.save,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                TextField(
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    context.read<AllTokensCubit>().filterTokens(value: value);
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.space2XSmall,
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        size: Sizes.icon2x,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.smallRadius),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      final tokenContractModel = state.filteredContracts[index];
                      return TokenContractItem(
                        tokenContractModel: tokenContractModel,
                        isOn: state.containContract(
                          contractModel: tokenContractModel,
                        ),
                        onChange: (isChecked) {
                          if (isChecked) {
                            context.read<AllTokensCubit>().addContract(
                                  contractModel: tokenContractModel,
                                );
                          } else {
                            context.read<AllTokensCubit>().removeContract(
                                  contractModel: tokenContractModel,
                                );
                          }
                        },
                      );
                    },
                    separatorBuilder: (_, __) {
                      return Divider(
                        height: 0.3,
                        color: Theme.of(context).colorScheme.borderColor,
                      );
                    },
                    itemCount: state.filteredContracts.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
