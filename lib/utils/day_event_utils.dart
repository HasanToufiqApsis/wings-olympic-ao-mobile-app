import '../constants/enum.dart';

class DayEventUtils {
  static DayEvent getDayEvent() {
    DateTime now = DateTime.now();
    DateTime morningStartTime = DateTime(now.year, now.month, now.day, 5);
    DateTime noonStartTime = DateTime(now.year, now.month, now.day, 12);
    DateTime afterNoonStartTime = DateTime(now.year, now.month, now.day, 16);
    DateTime eveningStartTime = DateTime(now.year, now.month, now.day, 18);
    DateTime afterNoonEndTime = DateTime(now.year, now.month, now.day, 22);

    if(now.isAfter(morningStartTime) && now.isBefore(noonStartTime)) {
      return DayEvent.morning;
    }
    else if(now.isAfter(noonStartTime) && now.isBefore(afterNoonStartTime)) {
      return DayEvent.noon;
    }
    else if(now.isAfter(afterNoonStartTime) && now.isBefore(eveningStartTime)) {
      return DayEvent.afternoon;
    }
    else if(now.isAfter(eveningStartTime) && now.isBefore(afterNoonEndTime)) {
      return DayEvent.evening;
    }
    else if(now.isAfter(afterNoonEndTime) && now.isBefore(morningStartTime)) {
      return DayEvent.night;
    }

    return DayEvent.morning;
  }
}
