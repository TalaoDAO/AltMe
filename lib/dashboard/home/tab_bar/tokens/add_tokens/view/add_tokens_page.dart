import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/add_tokens/add_tokens.dart';
import 'package:altme/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTokensPage extends StatelessWidget {
  const AddTokensPage({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}
