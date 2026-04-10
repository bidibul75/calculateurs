import 'history_export_service_stub.dart'
    if (dart.library.io) 'history_export_service_io.dart' as impl;

Future<String?> exportHistoryToTextFile(String content) {
  return impl.exportHistoryToTextFile(content);
}

bool get isHistoryFileExportSupported => impl.isHistoryFileExportSupported;

