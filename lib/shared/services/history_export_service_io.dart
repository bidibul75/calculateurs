// lib/shared/services/history_export_service_io.dart
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String?> exportHistoryToTextFile(String content) async {
  final directory = await getApplicationDocumentsDirectory();
  final fileName = 'calculator_history_${DateTime.now().millisecondsSinceEpoch}.txt';
  final file = File('${directory.path}${Platform.pathSeparator}$fileName');
  await file.writeAsString(content, flush: true);
  return file.path;
}

bool get isHistoryFileExportSupported => true;
