import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String?> exportResultToTextFile(String content, {required String prefix}) async {
  final directory = await getApplicationDocumentsDirectory();
  final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.txt';
  final file = File('${directory.path}${Platform.pathSeparator}$fileName');
  await file.writeAsString(content, flush: true);
  return file.path;
}

bool get isResultFileExportSupported => true;

