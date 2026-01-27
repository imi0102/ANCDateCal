import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _kAncDate = 'savedAncDate';
  static const _kPncDate = 'savedPncDate';

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

}