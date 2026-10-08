import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Saves a PNG screenshot of the app and attaches it to the running test.
Future<void> attachScreenshot(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byType(RepaintBoundary).first);
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    attachFile('build/screenshots/$name.png', png!.buffer.asUint8List());
  });
}

/// Writes [bytes] to [path] and attaches the file to the running test.
void attachFile(String path, List<int> bytes) {
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes);
  // ignore: avoid_print
  print('[[ATTACHMENT|$path]]');
}
