import 'package:altme/app/shared/widget/phrase_word.dart';
import 'package:flutter/material.dart';

class MnemonicDisplay extends StatelessWidget {
  const MnemonicDisplay({
    Key? key,
    required this.mnemonic,
  }) : super(key: key);

  final List<String> mnemonic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (i) {
          final j = 3 * i;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: PhraseWord(
                    order: j + 1,
                    word: mnemonic[j],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PhraseWord(
                    order: j + 2,
                    word: mnemonic[j + 1],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PhraseWord(
                    order: j + 3,
                    word: mnemonic[j + 2],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
