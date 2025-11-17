// IO implementation (mobile/desktop)
import 'dart:io';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
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
    final tmp = await getTemporaryDirectory();
    final file = File('${tmp.path}/$filename');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Date calculation PDF');
  }
}


PlatformUtils getPlatformUtils() => PlatformUtilsIO();