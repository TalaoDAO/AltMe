import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DisplayTermsOfUseCubit extends Cubit<bool> {
  DisplayTermsOfUseCubit() : super(false);

  void setExpanded({required bool isExpanded}) {
    emit(isExpanded);
  }
}

class DisplayTermsofUse extends StatefulWidget {
  const DisplayTermsofUse({
    Key? key,
    this.physics,
    this.shrinkWrap = true,
  }) : super(key: key);

  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  State<DisplayTermsofUse> createState() => _DisplayTermsofUseState();
}

class _DisplayTermsofUseState extends State<DisplayTermsofUse> {
  final log = getLogger('DisplayTermsofUse');

  late final displayTermsOfUseCubit = DisplayTermsOfUseCubit();

  Future<List<String>> getBodyData(String localeName) async {
    const String language = 'en';

    /// we disable display of privacy asset in phone language for now
    // final languagesList = ['fr', 'it', 'es', 'de'];
    // if (languagesList.contains(localeName)) {
    //   language = localeName;
    // }

    const privacyPathPart1 = 'assets/privacy/privacy_${language}_1.md';
    const privacyPathPart2 = 'assets/privacy/privacy_${language}_2.md';
    const termsPath = 'assets/terms/mobile_cgu_$language.md';

    final privacyDataPart1 = await _loadFile(privacyPathPart1);
    final privacyDataPart2 = await _loadFile(privacyPathPart2);
    final termsData = await _loadFile(termsPath);

    return [privacyDataPart1, privacyDataPart2, termsData];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<DisplayTermsOfUseCubit, bool>(
      bloc: displayTermsOfUseCubit,
      builder: (context, isExpand) {
        return FutureBuilder<List<String>>(
          future: getBodyData(l10n.localeName),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  childrenPadding: EdgeInsets.zero,
                  onExpansionChanged: (isExpanded) {
                    displayTermsOfUseCubit.setExpanded(
                      isExpanded: isExpanded,
                    );
                  },
                  tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                  trailing: const SizedBox.shrink(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MarkdownBody(
                        physics: widget.physics,
                        shrinkWrap: widget.shrinkWrap,
                        data: snapshot.data![0],
                      ),
                      Text(
                        isExpand ? l10n.showLess : l10n.showMore,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                  children: [
                    /// Privacry Policy part 2
                    MarkdownBody(
                      physics: widget.physics,
                      shrinkWrap: widget.shrinkWrap,
                      data: snapshot.data![1],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(),
                    ),

                    /// Terms
                    MarkdownBody(
                      physics: widget.physics,
                      shrinkWrap: widget.shrinkWrap,
                      data: snapshot.data![2],
                    ),
                  ],
                ),
              );
            }

            if (snapshot.error != null) {
              log.e(
                'something went wrong when loading privacy file',
                snapshot.error,
              );
              return const SizedBox.shrink();
            }

            return const Spinner();
          },
        );
      },
    );
  }

  Future<String> _loadFile(String path) async {
    return rootBundle.loadString(path);
  }
}

class MarkdownBody extends StatelessWidget {
  const MarkdownBody({
    Key? key,
    this.physics,
    this.shrinkWrap = true,
    required this.data,
  }) : super(key: key);

  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      physics: physics,
      shrinkWrap: shrinkWrap,
      data: data,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(
          color: Theme.of(context).colorScheme.markDownH1,
        ),
        h2: TextStyle(color: Theme.of(context).colorScheme.markDownH2),
        a: TextStyle(color: Theme.of(context).colorScheme.markDownA),
        p: TextStyle(color: Theme.of(context).colorScheme.markDownP),

        //onTapLink: (text, href, title) => _onTapLink(href),
      ),
    );
  }
}
