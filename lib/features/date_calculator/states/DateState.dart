import 'package:anc_date_calculator/core/enum/enums.dart';

class DateState {
  final DateTime? ancDate;
  final DateTime? pncDate;
  final bool loaded;
  final DateType dateType;

  const DateState({
    this.ancDate,
    this.pncDate,
    required this.loaded,
    required this.dateType,
  });

  DateState copyWith({
    Object? ancDate = _sentinel,
    Object? pncDate = _sentinel,
    bool? loaded,
    DateType? dateType,
  }) {
    return DateState(
      ancDate: ancDate == _sentinel ? this.ancDate : ancDate as DateTime?,
      pncDate: pncDate == _sentinel ? this.pncDate : pncDate as DateTime?,
      loaded: loaded ?? this.loaded,
      dateType: dateType ?? this.dateType,
    );
  }

  static const _sentinel = Object();
}
