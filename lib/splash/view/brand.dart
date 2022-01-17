import 'package:flutter/material.dart';

class Brand extends StatelessWidget {
  const Brand({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            width: 150,
            height: 150,
          ),
          Text(
            'Talao SSI wallet',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
