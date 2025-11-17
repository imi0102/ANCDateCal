import 'package:shared_preferences/shared_preferences.dart';


class StorageService {
  static const _kSavedDate = 'savedDate';


  Future<void> saveDate(DateTime date) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kSavedDate, date.millisecondsSinceEpoch);
  }


  Future<DateTime?> loadDate() async {
    final sp = await SharedPreferences.getInstance();
    final ms = sp.getInt(_kSavedDate);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }


  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kSavedDate);
  }
}