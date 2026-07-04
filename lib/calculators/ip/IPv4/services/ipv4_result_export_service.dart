// lib/calculators/ip/IPv4/services/ipv4_result_export_service.dart
import 'package:calculators/shared/services/result_export_service.dart' as shared_export;

Future<String?> exportIpv4ResultToTextFile(String content, {required String prefix}) {
  return shared_export.exportResultToTextFile(content, prefix: prefix);
}

bool get isIpv4ResultFileExportSupported => shared_export.isResultFileExportSupported;

