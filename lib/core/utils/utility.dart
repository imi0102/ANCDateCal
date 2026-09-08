import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class Utility {

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.app.anc_date_calculator';

  static void downloadApkWeb() {
    if (!kIsWeb) return;

    html.window.open(
      playStoreUrl,
      '_blank',
    );
  }
}
