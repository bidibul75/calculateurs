// lib/shared/services/result_feedback_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ExportToTextFile = Future<String?> Function(String content, {required String prefix});

void showResultSnackBar(BuildContext context, String message) {
  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> copyResultToClipboard({
  required BuildContext context,
  required String text,
  required String copiedMessage,
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) {
    return;
  }
  showResultSnackBar(context, copiedMessage);
}

Future<void> saveResultToFileWithFeedback({
  required BuildContext context,
  required String content,
  required String prefix,
  required bool isExportSupported,
  required ExportToTextFile exportToTextFile,
  required String unsupportedMessage,
  required String errorMessage,
  required String Function(String path) exportedMessageBuilder,
}) async {
  if (!isExportSupported) {
    showResultSnackBar(context, unsupportedMessage);
    return;
  }

  try {
    final filePath = await exportToTextFile(content, prefix: prefix);
    if (!context.mounted) {
      return;
    }
    if (filePath == null || filePath.isEmpty) {
      showResultSnackBar(context, errorMessage);
      return;
    }
    showResultSnackBar(context, exportedMessageBuilder(filePath));
  } catch (_) {
    if (!context.mounted) {
      return;
    }
    showResultSnackBar(context, errorMessage);
  }
}

