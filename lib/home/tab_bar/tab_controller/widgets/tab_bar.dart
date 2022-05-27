import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  const MyTab({Key? key, required this.icon, required this.text})
      : super(key: key);

  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Image.asset(icon, height: 25),
        ),
        Text(text, softWrap: false, overflow: TextOverflow.fade),
      ],
    );
  }
}
