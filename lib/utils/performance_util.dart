enum PerformanceType {
  none,
  stt,
  totalStt,
  strikeRate,
  geoFencing,
  bcp,
}

class PerformanceUtil {
  static String getString(PerformanceType type) {
    switch (type) {
      case PerformanceType.stt:
        return 'STT';
      case PerformanceType.totalStt:
        return 'Total STT';
      case PerformanceType.strikeRate:
        return 'Strike Rate';
      case PerformanceType.geoFencing:
        return 'Geo Fencing';
      case PerformanceType.bcp:
        return 'BCP';
      case PerformanceType.none:
        return '';
    }
  }

  static PerformanceType getEnum(String str) {
    switch (str) {
      case 'STT':
        return PerformanceType.stt;
      case 'Total STT':
        return PerformanceType.totalStt;
      case 'Strike Rate':
        return PerformanceType.strikeRate;
      case 'Geo Fencing':
        return PerformanceType.geoFencing;
      case 'BCP':
        return PerformanceType.bcp;
      default:
        return PerformanceType.none;
    }
  }
}
