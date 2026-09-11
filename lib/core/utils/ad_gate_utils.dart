class AdGateUtils {
  // ------------------------------------------------------------
  // CONFIGURATION
  // ------------------------------------------------------------

  static const int adInterval = 4;

  // ------------------------------------------------------------
  // SHOULD SHOW AD
  //
  // 1 → AD
  // 2 → FREE
  // 3 → FREE
  // 4 → FREE
  // 5 → AD
  // 6 → FREE
  // 7 → FREE
  // 8 → FREE
  // 9 → AD
  // ------------------------------------------------------------

  static bool shouldShowAd(int count) {
    return count % adInterval == 1;
  }
}