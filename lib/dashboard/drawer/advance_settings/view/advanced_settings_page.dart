import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/drawer/advance_settings/advance_settings.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (_) => const AdvancedSettingsPage(),
        settings: const RouteSettings(name: '/advanceSettingsPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdvanceSettingsCubit>.value(
      value: context.read<AdvanceSettingsCubit>(),
      child: const AdvancedSettingsView(),
    );
  }
}

class AdvancedSettingsView extends StatefulWidget {
  const AdvancedSettingsView({super.key});

  @override
  State<AdvancedSettingsView> createState() => _AdvancedSettingsViewState();
}

class _AdvancedSettingsViewState extends State<AdvancedSettingsView> {
  late final advancedSettingsCubit = context.read<AdvanceSettingsCubit>();
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.categories,
      titleLeading: const BackLeadingButton(),
      body: SingleChildScrollView(
        child: BlocBuilder<AdvanceSettingsCubit, AdvanceSettingsState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // ignore: lines_longer_than_80_chars
                  l10n.selectCredentialCategoryWhichYouWantToShowInCredentialList,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.gaming,
                  isSelected: state.isGamingEnabled,
                  onPressed: advancedSettingsCubit.toggleGamingRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.identity,
                  isSelected: state.isIdentityEnabled,
                  onPressed: advancedSettingsCubit.toggleIdentityRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.blockchainAccounts,
                  isSelected: state.isBlockchainAccountsEnabled,
                  onPressed:
                      advancedSettingsCubit.toggleBlockchainAccountsRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.educationCredentials,
                  isSelected: state.isEducationEnabled,
                  onPressed: advancedSettingsCubit.toggleEducationRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.community,
                  isSelected: state.isCommunityEnabled,
                  onPressed: advancedSettingsCubit.toggleCommunityRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.pass,
                  isSelected: state.isPassEnabled,
                  onPressed: advancedSettingsCubit.togglePassRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.other,
                  isSelected: state.isOtherEnabled,
                  onPressed: advancedSettingsCubit.toggleOtherRadio,
                ),
                Opacity(
                  opacity: 0.5,
                  child: AdvanceSettingsRadioItem(
                    title: l10n.socialMedia,
                    isSelected: state.isSocialMediaEnabled,
                    //onPressed: advanceSEttingsCubit.toggleSocialMediaRadio,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
