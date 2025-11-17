import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../..//../../core/services/storage_service.dart';


class DateNotifier extends StateNotifier<DateTime?> {
  final StorageService _storage = StorageService();
  DateNotifier() : super(null) {
    _load();
  }


  Future<void> _load() async {
    state = await _storage.loadDate();
  }


  Future<void> setDate(DateTime date) async {
    state = date;
    await _storage.saveDate(date);
  }


  Future<void> clear() async {
    state = null;
    await _storage.clear();
  }
}


final dateProvider = StateNotifierProvider<DateNotifier, DateTime?>((ref) => DateNotifier());