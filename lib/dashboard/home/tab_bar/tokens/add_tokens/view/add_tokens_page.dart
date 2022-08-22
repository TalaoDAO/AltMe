import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTokensPage extends StatelessWidget {
  const AddTokensPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/addTokensPage'),
      builder: (_) => const AddTokensPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTokensCubit>(
      create: (_) => AddTokensCubit(
        client: DioClient(
          Urls.tezToolBase,
          Dio(),
        ),
      ),
      child: const _AddTokensView(),
    );
  }
}

class _AddTokensView extends StatefulWidget {
  const _AddTokensView({Key? key}) : super(key: key);

  @override
  State<_AddTokensView> createState() => __AddTokensViewState();
}

class __AddTokensViewState extends State<_AddTokensView> {
  
  @override
  void initState() {
    Future<void>.microtask(context.read<AddTokensCubit>().getAllContracts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AddTokensCubit, AddTokensState>(
        builder: (context, state) {
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
              Text(
                l10n.addTokens,
                style: Theme.of(context).textTheme.headline5,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    return TokenContractItem(
                      tokenContractModel: state.contracts[index],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.spaceXSmall,
                      ),
                      child: Divider(
                        height: 0.3,
                        color: Theme.of(context).colorScheme.borderColor,
                      ),
                    );
                  },
                  itemCount: state.contracts.length,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
