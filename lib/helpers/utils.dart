import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_ai/helpers/ui_helper.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  final ByteData data = await rootBundle.load(path);

  final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);

  final ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

void insertOverlay(BuildContext context, Widget child) {
  return Overlay.of(context).insert(
    OverlayEntry(
      builder: (context) {
        return child;
      },
    ),
  );
}

Future<Unit> callHotLine(String? hotline) async {
  final Uri launchUriCall = Uri(
    scheme: 'tel',
    path: hotline ?? '',
  );
  await launchUrl(launchUriCall);
  return unit;
}

// void backPageOrHome({String pageName = ""}) => Get.until(
//       (route) => route is GetPageRoute && (route.routeName == pageName || route.routeName == MainPage.routeName),
//     );

Future<Unit> launchUri(String uri) async {
  if (await canLaunchUrl(Uri.parse(uri))) {
    await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  } else {
    showToast("Could not launch url");
  }
  return unit;
}
