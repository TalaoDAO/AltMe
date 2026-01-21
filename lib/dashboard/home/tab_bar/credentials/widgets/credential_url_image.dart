import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class CredentialUrlImage extends StatelessWidget {
  const CredentialUrlImage({required this.child, required this.url, super.key});
  final Widget child;
  final String url;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Stack(
        children: [
          CachedImageFromNetwork(
            url,
            fit: BoxFit.fill,
            width: double.infinity,
            bgColor: Colors.transparent,
            height: double.infinity,
            errorMessage: '',
            showLoading: false,
          ),
          // Opacity(
          //   opacity: 0.3,
          //   child: Container(
          //     color: Colors.black,
          //   ),
          // ),
          child,
        ],
      ),
    );
  }
}
