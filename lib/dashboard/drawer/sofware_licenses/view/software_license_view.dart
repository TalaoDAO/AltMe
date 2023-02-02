import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoftwareLicensePage extends StatelessWidget {
  const SoftwareLicensePage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (_) => const SoftwareLicensePage(),
        settings: const RouteSettings(name: '/SoftwareLicensePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoftwareLicenseCubit(),
      child: const SoftwareLicenseView(),
    );
  }
}

class SoftwareLicenseView extends StatefulWidget {
  const SoftwareLicenseView({super.key});

  @override
  State<SoftwareLicenseView> createState() => _SoftwareLicenseViewState();
}

class _SoftwareLicenseViewState extends State<SoftwareLicenseView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SoftwareLicenseCubit>().initialise();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<SoftwareLicenseCubit, SoftwareLicenseState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }
      },
      builder: (context, state) {
        return BasePage(
          title: l10n.softwareLicenses,
          titleAlignment: Alignment.topCenter,
          scrollView: false,
          titleLeading: const BackLeadingButton(),
          body: ListView.builder(
            itemCount: state.licenses.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return BackgroundCard(
                color: Theme.of(context).colorScheme.surfaceContainer,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.only(bottom: 8),
                child: TransparentInkWell(
                  onTap: () => Navigator.of(context).push<void>(
                    SoftwareLicenseDetailsPage.route(
                      licenseModel: state.licenses[index],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Expanded(
                                child: Text(
                                  state.licenses[index].title,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onBackground,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
