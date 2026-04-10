import 'ipv4_result_export_service_stub.dart'
    if (dart.library.io) 'ipv4_result_export_service_io.dart' as impl;

Future<String?> exportIpv4ResultToTextFile(String content, {required String prefix}) {
  return impl.exportIpv4ResultToTextFile(content, prefix: prefix);
}

bool get isIpv4ResultFileExportSupported => impl.isIpv4ResultFileExportSupported;

