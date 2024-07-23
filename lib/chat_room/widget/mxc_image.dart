import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

class MxcImage extends StatefulWidget {
  const MxcImage({
    required this.url,
    this.event,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.isThumbnail = true,
    this.animated = false,
    this.animationDuration = const Duration(milliseconds: 250),
    this.retryDuration = const Duration(seconds: 2),
    this.animationCurve = Curves.easeInOut,
    this.thumbnailMethod = ThumbnailMethod.scale,
    super.key,
  });

  final Event? event;
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isThumbnail;
  final bool animated;
  final Duration retryDuration;
  final Duration animationDuration;
  final Curve animationCurve;
  final ThumbnailMethod thumbnailMethod;
  final Widget Function(BuildContext context)? placeholder;

  @override
  State<MxcImage> createState() => _MxcImageState();
}

class _MxcImageState extends State<MxcImage> {
  Uint8List? _imageData;

  Future<void> _load() async {
    final event = widget.event;

    if (event != null) {
      final data = await event.downloadAndDecryptAttachment(
        getThumbnail: widget.isThumbnail,
      );
      if (data.msgType == MessageTypes.Image) {
        if (!mounted) return;
        setState(() {
          _imageData = data.bytes;
        });
        return;
      }
    }
  }

  void _tryLoad(_) async {
    if (_imageData != null) {
      return;
    }
    try {
      await _load();
    } catch (_) {
      if (!mounted) return;
      await Future<void>.delayed(widget.retryDuration);
      _tryLoad(_);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_tryLoad);
  }

  Widget placeholder(BuildContext context) =>
      widget.placeholder?.call(context) ??
      Container(
        width: 250,
        height: 250,
        alignment: Alignment.center,
        child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
      );

  @override
  Widget build(BuildContext context) {
    final data = _imageData;
    final hasData = data != null && data.isNotEmpty;

    return AnimatedCrossFade(
      crossFadeState:
          hasData ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
      firstChild: placeholder(context),
      secondChild: hasData
          ? TransparentInkWell(
              onTap: () {
                Navigator.of(context).push<void>(
                  PhotoViewer.route(
                    imageProvider: MemoryImage(data),
                  ),
                );
              },
              child: Image.memory(
                data,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                filterQuality: FilterQuality.none,
                errorBuilder: (context, __, s) {
                  _imageData = null;
                  WidgetsBinding.instance.addPostFrameCallback(_tryLoad);
                  return placeholder(context);
                },
              ),
            )
          : SizedBox(
              width: widget.width,
              height: widget.height,
            ),
    );
  }
}
