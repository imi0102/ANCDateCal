// platform_utils_io.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'platform_utils_stub.dart';

class PlatformUtilsIO implements PlatformUtils {
  @override
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Future<void> shareText(String text) async {
    await Share.share(text);
  }

  @override
  Future<void> savePdfAndShare(Uint8List bytes, String filename) async {
    try {
      // ⚡ Only for mobile/desktop
      final tmp = await getTemporaryDirectory();
      final file = File('${tmp.path}/$filename');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Date calculation PDF');
    } catch (e) {
      // fallback if getTemporaryDirectory fails
      print('Failed to get temporary directory: $e');
      // Optional: copy PDF to clipboard or notify user
      throw Exception(
          'Cannot save PDF: Platform not supported or temporary directory unavailable');
    }
  }
}

// ensure the correct platform is returned
PlatformUtils getPlatformUtils() => PlatformUtilsIO();
