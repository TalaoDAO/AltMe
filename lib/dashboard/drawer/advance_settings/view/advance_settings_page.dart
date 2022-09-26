import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/drawer/advance_settings/advance_settings.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvanceSettingsPage extends StatelessWidget {
  const AdvanceSettingsPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const AdvanceSettingsPage(),
        settings: const RouteSettings(name: '/advanceSettingsPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdvanceSettingsCubit>.value(
      value: context.read<AdvanceSettingsCubit>(),
      child: const AdvanceSettingsView(),
    );
  }
}

class AdvanceSettingsView extends StatefulWidget {
  const AdvanceSettingsView({Key? key}) : super(key: key);

  @override
  State<AdvanceSettingsView> createState() => _AdvanceSettingsViewState();
}

class _AdvanceSettingsViewState extends State<AdvanceSettingsView> {
  late final advanceSEttingsCubit = context.read<AdvanceSettingsCubit>();
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.advanceSettings,
      titleLeading: const BackLeadingButton(),
      body: SingleChildScrollView(
        child: BlocBuilder<AdvanceSettingsCubit, AdvanceSettingsState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectCredentialCategoryWhichYouWantToShowInCredentialList,
                  style: Theme.of(context).textTheme.headline6,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.gaming,
                  isSelected: state.isGamingEnabled,
                  onPressed: advanceSEttingsCubit.toggleGamingRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.identity,
                  isSelected: state.isIdentityEnabled,
                  onPressed: advanceSEttingsCubit.toggleIdentityRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.payment,
                  isSelected: state.isPaymentEnabled,
                  onPressed: advanceSEttingsCubit.togglePaymentRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.community,
                  isSelected: state.isCommunityEnabled,
                  onPressed: advanceSEttingsCubit.toggleCommunityRadio,
                ),
                AdvanceSettingsRadioItem(
                  title: l10n.other,
                  isSelected: state.isOtherEnabled,
                  onPressed: advanceSEttingsCubit.toggleOtherRadio,
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
