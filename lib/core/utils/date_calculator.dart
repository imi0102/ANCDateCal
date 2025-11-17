class DateCalculator {
  DateCalculator._();
  static DateTime calculate(DateTime base, int days) => base.add(Duration(days: days - 1));
}