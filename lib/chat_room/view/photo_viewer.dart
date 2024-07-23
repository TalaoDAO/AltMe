import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
  const PhotoViewer({
    super.key,
    required this.imageProvider,
  });

  final ImageProvider imageProvider;

  static Route<dynamic> route({required ImageProvider imageProvider}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/PhotoViewer'),
      builder: (_) => PhotoViewer(imageProvider: imageProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      useSafeArea: false,
      scrollView: false,
      body: Dismissible(
        key: const Key('photo_view_gallery'),
        direction: DismissDirection.down,
        onDismissed: (direction) {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Center(
              child: PhotoView(
                imageProvider: imageProvider,
                loadingBuilder: (context, event) => const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Positioned.directional(
              end: 16,
              textDirection: Directionality.of(context),
              top: 56,
              child: CloseButton(
                color: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
