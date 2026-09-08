import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _kAncDate = 'savedAncDate';
  static const _kPncDate = 'savedPncDate';
  // Rewarded Ad
  static const _kRewardedUsageCount =
      'rewardedUsageCount';

  static const _kRewardedUsageDate =
      'rewardedUsageDate';
  // -------- ANC --------
  Future<void> saveAncDate(DateTime date) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kAncDate, date.millisecondsSinceEpoch);
  }

  Future<DateTime?> loadAncDate() async {
    final sp = await SharedPreferences.getInstance();
    final ms = sp.getInt(_kAncDate);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  Future<void> clearAnc() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kAncDate);
  }

  // -------- PNC --------
  Future<void> savePncDate(DateTime date) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kPncDate, date.millisecondsSinceEpoch);
  }

  Future<DateTime?> loadPncDate() async {
    final sp = await SharedPreferences.getInstance();
    final ms = sp.getInt(_kPncDate);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  Future<void> clearPnc() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kPncDate);
  }

  // ============================================================
  // REWARDED AD COUNTER
  // ============================================================

  Future<int> incrementRewardedUsage() async {
    final sp = await SharedPreferences.getInstance();

    final today = _todayKey();

    final savedDate =
    sp.getString(_kRewardedUsageDate);

    int count;

    if (savedDate != today) {
      // New day → start from 1
      count = 1;

      await sp.setString(
        _kRewardedUsageDate,
        today,
      );
    } else {
      count =
          (sp.getInt(_kRewardedUsageCount) ?? 0) + 1;
    }

    await sp.setInt(
      _kRewardedUsageCount,
      count,
    );

    return count;
  }

  String _todayKey() {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  // Optional: testing
  Future<void> resetRewardedUsage() async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(_kRewardedUsageCount);
    await sp.remove(_kRewardedUsageDate);
  }
}