import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class Utility {

  static void downloadApkWeb() {
    if (!kIsWeb) return;

    html.window.open(
      '/assets/apk/app-release.apk',
      '_blank',
    );
  }
}
