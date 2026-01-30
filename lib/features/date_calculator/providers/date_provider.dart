import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';
import 'package:anc_date_calculator/features/date_calculator/states/DateState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../..//../../core/services/storage_service.dart';

class DateNotifier extends StateNotifier<DateState> {
  final StorageService _storage = StorageService();

  DateNotifier()
    : super(
        const DateState(
          ancDate: null,
          pncDate: null,
          visitType: VisitType.pnc,
          loaded: false,
        ),
      ) {
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final anc = await _storage.loadAncDate();
    final pnc = await _storage.loadPncDate();

    state = state.copyWith(ancDate: anc, pncDate: pnc, loaded: true);
  }

  Future<void> setAncDate(DateTime date) async {
    state = state.copyWith(ancDate: date, visitType: VisitType.anc);
    await _storage.saveAncDate(date);
  }

  Future<void> setPncDate(DateTime date) async {
    state = state.copyWith(pncDate: date, visitType: VisitType.pnc);
    await _storage.savePncDate(date);
  }

  Future<void> clearAnc() async {
    state = state.copyWith(ancDate: null);
    await _storage.clearAnc();
  }

  Future<void> clearPnc() async {
    state = state.copyWith(pncDate: null);
    await _storage.clearPnc();
  }
}

final dateProvider = StateNotifierProvider<DateNotifier, DateState?>(
  (ref) => DateNotifier(),
);
