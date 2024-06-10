import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              margin: const EdgeInsets.all(Sizes.spaceXSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(Sizes.largeRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.walletSettingsDescription,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: LanguageType.values.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final languageType = LanguageType.values[index];

                      return Column(
                        children: [
                          if (index != 0)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Divider(
                                height: 0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.12),
                              ),
                            ),
                          ListTile(
                            onTap: () async {
                              await context
                                  .read<LangCubit>()
                                  .setLocale(Locale(languageType.name));
                            },
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xFFDDDDEE),
                                width: 0.5,
                              ),
                            ),
                            title: Text(
                              languageType.getTitle(
                                l10n: l10n,
                                name: languageType.name,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                            trailing: Icon(
                              state.languageType == languageType
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: Sizes.icon2x,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
