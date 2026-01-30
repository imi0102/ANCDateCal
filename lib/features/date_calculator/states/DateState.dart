import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';

class DateState {
  final DateTime? ancDate;
  final DateTime? pncDate;
  final bool loaded;
  final VisitType visitType;

  const DateState({
    this.ancDate,
    this.pncDate,
    required this.loaded,
    required this.visitType,
  });

  DateState copyWith({
    Object? ancDate = _sentinel,
    Object? pncDate = _sentinel,
    bool? loaded,
    VisitType? visitType,
  }) {
    return DateState(
      ancDate: ancDate == _sentinel ? this.ancDate : ancDate as DateTime?,
      pncDate: pncDate == _sentinel ? this.pncDate : pncDate as DateTime?,
      loaded: loaded ?? this.loaded,
      visitType: visitType ?? this.visitType,
    );
  }

  static const _sentinel = Object();
}
