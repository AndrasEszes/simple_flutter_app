import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_api/hooks.dart';

final _unsafeCharacters = RegExp(r'["*/:<>?\\|]');

/// Saves [bytes] as an attachment of the running test, named by the Bitrise convention
/// `<classname>__<name>__<label>.<ext>`, so it shows up under the test on the Tests tab.
void attach(List<int> bytes, String label, {String extension = 'png'}) {
  final fileName = '${_className()}__${TestHandle.current.name}__$label.$extension'
      .replaceAll(_unsafeCharacters, '_');
  File('build/test-attachments/$fileName')
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes);
}

/// Saves a PNG screenshot of the app as an attachment of the running test.
Future<void> attachScreenshot(WidgetTester tester, String label) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byType(RepaintBoundary).first);
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    attach(png!.buffer.asUint8List(), label);
  });
}

// The class name tojunit writes: the test file's path without "_test.dart",
// with "/" replaced by "." and "-" by "_".
String _className() {
  final testFile = StackTrace.current
      .toString()
      .split('\n')
      .map((line) => RegExp(r'(file://\S+_test\.dart)').firstMatch(line)?.group(1))
      .firstWhere((match) => match != null)!;
  final path = Uri.parse(testFile).toFilePath();
  return path
      .substring(0, path.length - '_test.dart'.length)
      .replaceAll(RegExp(r'[\\/]'), '.')
      .replaceAll('-', '_');
}
