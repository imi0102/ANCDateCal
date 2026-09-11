import 'dart:io';
import 'package:flutter/foundation.dart';

class AdIds {
  static bool releaseMode = kReleaseMode;

  static String testAdmobAndroidAppId =
      "ca-app-pub-4331629068974197~2032697395";
  static String testAppOpenAndroidId = "ca-app-pub-3940256099942544/9257395921";
  static String testBannerAndroidId = "ca-app-pub-3940256099942544/6300978111";
  static String testRewardAndroidId = "ca-app-pub-3940256099942544/5224354917";
  static String testRewardInterstitialAndroidId =
      "ca-app-pub-3940256099942544/5354046379";

  //iOS Test IDs
  static String testAdmobIOSAppId = "ca-app-pub-3940256099942544~1458002511";
  static String testAppOpenIosId = "ca-app-pub-3940256099942544/5575463023";
  static String testBannerIosId = "ca-app-pub-3940256099942544/2934735716";
  static String testRewardIosId = "ca-app-pub-3940256099942544/1712485313";
  static String testRewardInterstitialIosId =
      "ca-app-pub-3940256099942544/6978759866";
  static String testNativeAdvanceIOSId =
      "ca-app-pub-3940256099942544/2521693316";
  static String testInterstitialIOSId =
      "ca-app-pub-3940256099942544/4411468910";

  // ✅ TEST IDs (safe)
  static const banner = 'ca-app-pub-3940256099942544/6300978111';
  static const rewarded = 'ca-app-pub-3940256099942544/5224354917';

  static String admobAppId = Platform.isAndroid
      ? releaseMode
            ? "ca-app-pub-6994441308833711~5050261717" //Live Android Id
            : testAdmobAndroidAppId //Test Android ID
      : releaseMode
      ? "" //Apple Live Id
      : testAppOpenIosId; //Apple Test Id

  //Banner ID
  static String bannerAncAdUnitId = kIsWeb
      ? '' // 👈 No ads on Web (or use Web test id if needed)
      : Platform.isAndroid
      ? (releaseMode
            ? 'ca-app-pub-6994441308833711/4997305955' // Live Android
            : testBannerAndroidId) // Test Android
      : Platform.isIOS
      ? (releaseMode
            ? 'IOS_LIVE_AD_UNIT_ID' // Live iOS
            : testBannerIosId) // Test iOS
      : '';
  static String bannerPncAdUnitId = kIsWeb
      ? ''
      : Platform.isAndroid
      ? (releaseMode
            ? "ca-app-pub-6994441308833711/9451556282" // Live Android Id
            : testBannerAndroidId) // Test Android ID
      : Platform.isIOS
      ? (releaseMode
            ? "" // Apple Live Id
            : testBannerIosId)
      : "";

  static String dateSelectionRewardUnitId = kIsWeb
      ? ''
      : Platform.isAndroid
      ? (releaseMode
            ? "ca-app-pub-6994441308833711/9859205924" // Live Android Id
            : rewarded) // Test Android ID
      : Platform.isIOS
      ? (releaseMode
            ? "" // Apple Live Id
            : rewarded)
      : "";
  static String rewardedAncAdUnitId = kIsWeb
      ? ''
      : Platform.isAndroid
      ? (releaseMode
            ? "ca-app-pub-6994441308833711/9813410790" // Live Android Id
            : rewarded) // Test Android ID
      : Platform.isIOS
      ? (releaseMode
            ? "" // Apple Live Id
            : rewarded)
      : "";

  static String rewardedPncAdUnitId = kIsWeb
      ? ''
      : Platform.isAndroid
      ? (releaseMode
            ? "ca-app-pub-6994441308833711/1993136268" // Live Android Id
            : rewarded) // Test Android ID
      : Platform.isIOS
      ? (releaseMode
            ? "" // Apple Live Id
            : rewarded)
      : "";
}
