class DateRange {
  final DateTime from;
  final DateTime? to;

  const DateRange({
    required this.from,
    this.to,
  });

  bool get isSingle => to == null;
}
