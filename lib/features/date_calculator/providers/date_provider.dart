import 'package:anc_date_calculator/core/enum/enums.dart';
import 'package:anc_date_calculator/features/date_calculator/states/DateState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../..//../../core/services/storage_service.dart';

class DateNotifier extends StateNotifier<DateState?> {
  final StorageService _storage = StorageService();

  DateNotifier()
    : super(
        const DateState(
          ancDate: null,
          pncDate: null,
          dateType: DateType.pnc,
          loaded: false,
        ),
      ) {
    _loadPnc();
    _loadAnc();
  }

  Future<void> _loadPnc() async {
    final d = await _storage.loadPncDate();
    state = DateState(pncDate: d, loaded: true, dateType: DateType.pnc);
  }

  Future<void> setPncDate(DateTime date) async {
    state = state?.copyWith(pncDate: date);
    await _storage.savePncDate(date);
  }

  Future<void> clearPnc() async {
    state = state?.copyWith(pncDate: null);
    await _storage.clearPnc();
  }

  Future<void> _loadAnc() async {
    final d = await _storage.loadAncDate();
    state = DateState(ancDate: d, loaded: true, dateType: DateType.anc);
  }

  Future<void> setAncDate(DateTime date) async {
    state = state?.copyWith(ancDate: date);
    await _storage.saveAncDate(date);
  }

  Future<void> clearAnc() async {
    state = state?.copyWith(ancDate: null);
    await _storage.clearAnc();
  }
}

final dateProvider = StateNotifierProvider<DateNotifier, DateState?>(
  (ref) => DateNotifier(),
);
