import 'result_export_service_stub.dart'
    if (dart.library.io) 'result_export_service_io.dart' as impl;

Future<String?> exportResultToTextFile(String content, {required String prefix}) {
  return impl.exportResultToTextFile(content, prefix: prefix);
}

bool get isResultFileExportSupported => impl.isResultFileExportSupported;

