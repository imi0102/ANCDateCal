import 'dart:typed_data';
import 'dart:convert';
import 'platform_utils_stub.dart';
import 'dart:html' as html;


class PlatformUtilsWeb implements PlatformUtils {
  @override
  Future<void> copyToClipboard(String text) async {
    await html.window.navigator.clipboard?.writeText(text);
  }


  @override
  Future<void> shareText(String text) async {
// best-effort: copy to clipboard and show a notification via alert
    await copyToClipboard(text);
    html.window.alert('Text copied to clipboard for sharing');
  }


  @override
  Future<void> savePdfAndShare(Uint8List bytes, String filename) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}


PlatformUtils getPlatformUtils() => PlatformUtilsWeb();