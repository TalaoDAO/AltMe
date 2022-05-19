import 'package:flutter/material.dart';

class MyCollectionText extends StatelessWidget {
  const MyCollectionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'My collection',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
