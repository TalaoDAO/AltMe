import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Future<void> onRefresh() async {
    await context.read<CredentialsCubit>().loadAllCredentials();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scrollView: false,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocBuilder<CredentialsCubit, CredentialsState>(
        builder: (context, state) {
          return DiscoverCredentialCategoryList(
            onRefresh: onRefresh,
            dummyCredentials: state.dummyCredentials,
          );
        },
      ),
    );
  }
}
