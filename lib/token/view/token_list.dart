// ignore_for_file: lines_longer_than_80_chars

import 'dart:math';

import 'package:flutter/material.dart';

class TokenList extends StatelessWidget {
  const TokenList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      // The items in this example are fixed to 48 pixels
      // high. This matches the Material Design spec for
      // ListTile widgets.
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // This builder is called for each child.
          // In this example, we just number each list item.
          final randomNumber = Random();
          return ListTile(
            leading: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.surfing_rounded),
            ),
            title: Text(
              '${((randomNumber.nextDouble() * index * 10000000 + 1).round() / 100000).toString()} TALAO',
              textAlign: TextAlign.end,
            ),
            trailing: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.search),
            ),
          );
        },
        // The childCount of the SliverChildBuilderDelegate
        // specifies how many children this inner list
        // has. In this example, each tab has a list of
        // exactly 30 items, but this is arbitrary.
        childCount: 30,
      ),
    );
  }
}
