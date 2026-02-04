import 'package:anc_date_calculator/features/date_calculator/domain/entities/date_range.dart';
import 'package:anc_date_calculator/features/date_calculator/domain/entities/visit_period.dart';

class DateCalculator {
  DateCalculator._();

  static DateTime singleDate(DateTime base, int days) =>
      base.add(Duration(days: days));

  static DateTime startDate(DateTime base, int prevDays) =>
      base.add(Duration(days: prevDays));

  static DateTime endDate(DateTime base, int days) =>
      base.add(Duration(days: days - 1));

  static DateTime ancEndDate(DateTime base, int days) =>
      base.add(Duration(days: days));

  /// ✅ ONE function for ANC + PNC
  static DateRange calculateRange({
    required DateTime base,
    required List<VisitPeriod> periods,
    required int index,
    required VisitType visitType,
  }) {
    final period = periods[index];

    // SINGLE DATE (EDD / Registration)
    if (period.isSingle) {
      return DateRange(from: singleDate(base, period.toDays!));
    }

    // RANGE
    // final prevDays = index == 0 ? 0 : periods[index - 1].days;

    return DateRange(
      from: startDate(base, period.fromDays!),
      to: visitType == VisitType.anc
          ? ancEndDate(base, period.toDays!)
          : endDate(base, period.toDays!),
    );
  }

  static String centerWordBetween(String top, String bottom, String word) {
    final maxLen = top.length > bottom.length ? top.length : bottom.length;
    final pad = ((maxLen - word.length) / 2).floor();
    return ' ' * pad + word;
  }
}
