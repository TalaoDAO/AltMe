import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Future<void> onRefresh() async {}

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
      body: DiscoverCredentialCategoryList(), //TODO(Taleb): update the inputs
      // TODO(Taleb): remove this after migrating code
      // return DiscoverCredentialList(
      //   onRefresh: () async {
      //     await context
      //         .read<CredentialListCubit>()
      //         .initialise(context.read<CredentialsCubit>());
      //   },
      //   state: state.populate(
      //     gamingCredentials: credentialListCubit.dummyListFromCategory(
      //       state.gamingCategories,
      //     ),
      //     communityCredentials: credentialListCubit.dummyListFromCategory(
      //       state.communityCategories,
      //     ),
      //     identityCredentials: credentialListCubit.dummyListFromCategory(
      //       state.identityCategories,
      //     ),
      //     myProfessionalCredentials:
      //         credentialListCubit.dummyListFromCategory(
      //       state.myProfessionalCategories,
      //     ),
      //     blockchainAccountsCredentials: [],
      //     educationCredentials: [],
      //     othersCredentials: [],
      //   ),
      // );
    );
  }
}
