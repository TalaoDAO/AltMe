import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AddTokensPage extends StatelessWidget {
  const AddTokensPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _AddTokensView();
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
