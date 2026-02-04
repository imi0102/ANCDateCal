import '../../features/date_calculator/domain/entities/visit_period.dart';

/// ---------------- PNC ----------------
const List<VisitPeriod> pncPeriods = [
  VisitPeriod(
    label: 'પહેલી મુલાકાત (1 થી 2 દિવસે)',
    ////days: 2,
    fromDays: 0,
    toDays: 2,
  ),
  VisitPeriod(
    label: 'બીજી મુલાકાત (3 થી 7 દિવસે)',
    //days: 7,
    fromDays: 2,
    toDays: 7,
  ),
  VisitPeriod(
    label: 'ત્રીજી મુલાકાત (8 થી 14 દિવસે)',
    //days: 14,
    fromDays: 7,
    toDays: 14,
  ),
  VisitPeriod(
    label: 'ચોથી મુલાકાત (15 થી 21 દિવસે)',
    //days: 21,
    fromDays: 14,
    toDays: 21,
  ),
  VisitPeriod(
    label: 'પાંચમી મુલાકાત (22 થી 31 દિવસે)',
    //days: 31,
    fromDays: 21,
    toDays: 31,
  ),
  VisitPeriod(
    label: 'છઠ્ઠી મુલાકાત (32 થી 42 દિવસે)',
    //days: 42,
    fromDays: 31,
    toDays: 42,
  ),
];

/// ---------------- ANC ----------------
const List<VisitPeriod> ancPeriods = [
  VisitPeriod(
    label: 'અંદાજિત પ્રસૂતિ તારીખ (EDD)',
    //days: 280,
    fromDays: 0,
    toDays: 280,
    kind: PeriodKind.singleDate,
  ),
  VisitPeriod(
    label: 'અર્લી ANC નોંધણી (12 અઠવાડિયા સુધી)',
    //days: 83,
    fromDays: 0,
    toDays: 83,
    kind: PeriodKind.singleDate,
  ),
  VisitPeriod(
    label: 'પ્રથમ ANC મુલાકાત (12 અઠવાડિયા)',
    //days: 90,
    fromDays: 0,
    toDays: 90,
  ),
  VisitPeriod(
    label: 'બીજી ANC મુલાકાત (20 અઠવાડિયા)',
    //days: 140,
    fromDays: 91,
    toDays: 140,
  ),
  VisitPeriod(
    label: 'ત્રીજી ANC મુલાકાત (26 અઠવાડિયા)',
    //days: 182,
    fromDays: 141,
    toDays: 182,
  ),
  VisitPeriod(
    label: 'ચોથી ANC મુલાકાત (30 અઠવાડિયા)',
    //days: 210,
    fromDays: 183,
    toDays: 210,
  ),
  VisitPeriod(
    label: 'પાંચમી ANC મુલાકાત (34 અઠવાડિયા)',
    //days: 238,
    fromDays: 211,
    toDays: 238,
  ),
  VisitPeriod(
    label: 'છઠ્ઠી ANC મુલાકાત (36 અઠવાડિયા)',
    //days: 252,
    fromDays: 239,
    toDays: 252,
  ),
  VisitPeriod(
    label: 'સાતમી ANC મુલાકાત (38 અઠવાડિયા)',
    //days: 266,
    fromDays: 253,
    toDays: 266,
  ),
  VisitPeriod(
    label: 'આઠમી ANC મુલાકાત (40 અઠવાડિયા)',
    //days: 280,
    fromDays: 267,
    toDays: 280,
  ),
];
