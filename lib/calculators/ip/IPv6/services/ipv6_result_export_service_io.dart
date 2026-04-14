import 'package:calculators/shared/services/result_export_service_io.dart' as shared_export;

Future<String?> exportIpv6ResultToTextFile(String content, {required String prefix}) async {
  return shared_export.exportResultToTextFile(content, prefix: prefix);
}

bool get isIpv6ResultFileExportSupported => shared_export.isResultFileExportSupported;

