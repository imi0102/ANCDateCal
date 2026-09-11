class TrialUtils {
  // ------------------------------------------------------------
  // CONFIGURATION
  // ------------------------------------------------------------

  static const int freeTrialDays = 5;

  // ------------------------------------------------------------
  // GET TRIAL END DATE
  // ------------------------------------------------------------

  static DateTime getTrialEndDate(
      DateTime firstInstallDate,
      ) {
    return firstInstallDate.add(
      const Duration(
        days: freeTrialDays,
      ),
    );
  }

  // ------------------------------------------------------------
  // CHECK TRIAL ACTIVE
  // ------------------------------------------------------------

  static bool isTrialActive(
      DateTime firstInstallDate,
      ) {
    final now = DateTime.now();

    final trialEndDate =
    getTrialEndDate(firstInstallDate);

    return now.isBefore(trialEndDate);
  }

  // ------------------------------------------------------------
  // GET REMAINING TIME
  // ------------------------------------------------------------

  static Duration getRemainingTime(
      DateTime firstInstallDate,
      ) {
    final now = DateTime.now();

    final trialEndDate =
    getTrialEndDate(firstInstallDate);

    final remaining =
    trialEndDate.difference(now);

    if (remaining.isNegative) {
      return Duration.zero;
    }

    return remaining;
  }

  // ------------------------------------------------------------
  // GET REMAINING DAYS
  // ------------------------------------------------------------

  static int getRemainingDays(
      DateTime firstInstallDate,
      ) {
    final remaining =
    getRemainingTime(firstInstallDate);

    return remaining.inDays;
  }
}