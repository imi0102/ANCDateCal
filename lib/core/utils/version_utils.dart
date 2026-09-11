class VersionUtils {
  static bool isVersionLessThan(
      String current,
      String minimum,
      ) {
    final currentParts =
    _parse(current);

    final minimumParts =
    _parse(minimum);

    final length =
    currentParts.length >
        minimumParts.length
        ? currentParts.length
        : minimumParts.length;

    for (int i = 0; i < length; i++) {
      final currentValue =
      i < currentParts.length
          ? currentParts[i]
          : 0;

      final minimumValue =
      i < minimumParts.length
          ? minimumParts[i]
          : 0;

      if (currentValue <
          minimumValue) {
        return true;
      }

      if (currentValue >
          minimumValue) {
        return false;
      }
    }

    return false;
  }

  static List<int> _parse(
      String version,
      ) {
    return version
        .split('+')
        .first
        .split('.')
        .map(
          (e) => int.tryParse(e) ?? 0,
    )
        .toList();
  }
}