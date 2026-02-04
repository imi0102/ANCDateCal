import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsInitializer {
  static Future<void> init() async {
    if (kIsWeb) {
      return;
    }

    await MobileAds.instance.initialize();
  }
}
