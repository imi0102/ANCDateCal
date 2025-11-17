import 'dart:typed_data';


abstract class PlatformUtils {
  Future<void> savePdfAndShare(Uint8List bytes, String filename);
  Future<void> shareText(String text);
  Future<void> copyToClipboard(String text);
}


PlatformUtils getPlatformUtils() => throw UnsupportedError('PlatformUtils not configured');