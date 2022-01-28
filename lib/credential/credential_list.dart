import 'package:flutter/material.dart';

class CredentialList extends StatelessWidget {
  const CredentialList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset('assets/images/$index.png'),
            ),
          );
        },
        childCount: 13,
      ),
    );
  }
}
