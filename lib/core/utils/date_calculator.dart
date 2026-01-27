class DateCalculator {
  DateCalculator._();

  //static DateTime calculate(DateTime base, int days) => base.add(Duration(days: days - 1));

  static DateTime startDate(DateTime base, int prevDays) {
    return base.add(Duration(days: prevDays));
  }

  static DateTime endDate(DateTime base, int days) {
    return base.add(Duration(days: days - 1));
  }

  static String centerWordBetween(String top, String bottom, String word) {
    final maxLen = top.length > bottom.length ? top.length : bottom.length;
    final pad = ((maxLen - word.length) / 2).floor();
    return ' ' * pad + word;
  }

}
