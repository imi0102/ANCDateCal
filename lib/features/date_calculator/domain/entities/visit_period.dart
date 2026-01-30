enum VisitType {
  anc,
  pnc,
}

enum PeriodKind {
  range,        // normal from–to
  singleDate,   // EDD / registration
}

class VisitPeriod {
  final String label;
  //final int days;
  final int? fromDays;
  final int? toDays;
  final PeriodKind kind;

  const VisitPeriod({
    required this.label,
    //required this.days,
     this.fromDays,
     this.toDays,
    this.kind = PeriodKind.range,
  });

  bool get isSingle => kind == PeriodKind.singleDate;
}
