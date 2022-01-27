import 'package:flutter/material.dart';

class TokenList extends StatelessWidget {
  const TokenList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      // The items in this example are fixed to 48 pixels
      // high. This matches the Material Design spec for
      // ListTile widgets.
      itemExtent: 48,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // This builder is called for each child.
          // In this example, we just number each list item.
          return ListTile(
            title: Center(child: Text('Item $index')),
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
