import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // ============================================================
  // ANC / PNC
  // ============================================================

  static const String _kAncDate = 'savedAncDate';
  static const String _kPncDate = 'savedPncDate';

  // ============================================================
  // REWARDED AD
  // ============================================================

  static const String _kRewardedUsageCount = 'rewardedUsageCount';

  static const String _kRewardedUsageDate = 'rewardedUsageDate';

  // ============================================================
  // FREE TRIAL
  // ============================================================

  static const String _kFirstInstallDate = 'first_install_date';

  // ============================================================
  // ANC
  // ============================================================

  Future<void> saveAncDate(DateTime date) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setInt(_kAncDate, date.millisecondsSinceEpoch);
  }

  Future<DateTime?> loadAncDate() async {
    final sp = await SharedPreferences.getInstance();

    final milliseconds = sp.getInt(_kAncDate);

    if (milliseconds == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<void> clearAnc() async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(_kAncDate);
  }

  // ============================================================
  // PNC
  // ============================================================

  Future<void> savePncDate(DateTime date) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setInt(_kPncDate, date.millisecondsSinceEpoch);
  }

  Future<DateTime?> loadPncDate() async {
    final sp = await SharedPreferences.getInstance();

    final milliseconds = sp.getInt(_kPncDate);

    if (milliseconds == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<void> clearPnc() async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(_kPncDate);
  }

  // ============================================================
  // REWARDED AD COUNTER
  //
  // Counter resets every new day.
  //
  // Example:
  //
  // 1 → AD
  // 2 → FREE
  // 3 → FREE
  // 4 → FREE
  // 5 → AD
  //
  // Next day:
  //
  // 1 → AD
  // 2 → FREE
  // ...
  // ============================================================

  Future<int> incrementRewardedUsage() async {
    final sp = await SharedPreferences.getInstance();

    final today = _todayKey();

    final savedDate = sp.getString(_kRewardedUsageDate);

    int count;

    if (savedDate != today) {
      // --------------------------------------------------------
      // New day
      // --------------------------------------------------------

      count = 1;

      await sp.setString(_kRewardedUsageDate, today);
    } else {
      // --------------------------------------------------------
      // Same day
      // --------------------------------------------------------

      count = (sp.getInt(_kRewardedUsageCount) ?? 0) + 1;
    }

    await sp.setInt(_kRewardedUsageCount, count);

    return count;
  }

  // ============================================================
  // GET CURRENT REWARDED USAGE
  // ============================================================

  Future<int> getRewardedUsage() async {
    final sp = await SharedPreferences.getInstance();

    final today = _todayKey();

    final savedDate = sp.getString(_kRewardedUsageDate);

    // If the saved date is not today,
    // usage for today is effectively 0.
    if (savedDate != today) {
      return 0;
    }

    return sp.getInt(_kRewardedUsageCount) ?? 0;
  }

  // ============================================================
  // TODAY KEY
  // ============================================================

  String _todayKey() {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // RESET REWARDED USAGE
  // ============================================================

  Future<void> resetRewardedUsage() async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(_kRewardedUsageCount);

    await sp.remove(_kRewardedUsageDate);
  }

  // ============================================================
  // FIRST INSTALL DATE
  // ============================================================

  Future<DateTime?> getFirstInstallDate() async {
    final sp = await SharedPreferences.getInstance();

    final value = sp.getString(_kFirstInstallDate);

    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  Future<void> saveFirstInstallDate(DateTime date) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString(_kFirstInstallDate, date.toIso8601String());
  }

  // ============================================================
  // RESET FIRST INSTALL DATE
  //
  // Testing only.
  // ============================================================

  Future<void> resetFirstInstallDate() async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(_kFirstInstallDate);
  }

  // ============================================================
  // RESET EVERYTHING RELATED TO AD GATE
  //
  // Testing only.
  //
  // This will:
  // - Remove 5-day trial date
  // - Remove rewarded usage
  // ============================================================

  Future<void> resetAdGateForTesting() async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(_kFirstInstallDate);

    await sp.remove(_kRewardedUsageCount);

    await sp.remove(_kRewardedUsageDate);
  }
}
