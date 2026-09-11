import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> openPlayStore() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.app.anc_date_calculator',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
