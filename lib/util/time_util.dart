int getMaturityDay(String? selectedTimePeriod, DateTime? selectedDate) {
  if (selectedTimePeriod != null) {
    return convertTimePeriodToMilliseconds(selectedTimePeriod);
  } else {
    return selectedDate != null ? selectedDate.millisecondsSinceEpoch : 0;
  }
}

int convertTimePeriodToMilliseconds(String timePeriod) {
  DateTime now = DateTime.now().toUtc();
  DateTime futureDate;

  if (timePeriod == '1 month') {
    futureDate = now.add(Duration(days: 30));
  } else if (timePeriod == '3 months') {
    futureDate = now.add(Duration(days: 90));
  } else if (timePeriod == '60 months') {
    futureDate = now.add(Duration(days: 1825));
  } else if (timePeriod == '1 year') {
    futureDate = now.add(Duration(days: 365));
  } else if (timePeriod == '2 years') {
    futureDate = now.add(Duration(days: 730));
  } else if (timePeriod == '3 years') {
    futureDate = now.add(Duration(days: 1095));
  } else {
    return 0;
  }

  return futureDate.millisecondsSinceEpoch;
}

int convertTimePeriodToMonths(String timePeriod) {
  switch (timePeriod) {
    case '1 month':
      return 1;
    case '3 months':
      return 3;
    case '60 months':
      return 60;
    case '1 year':
      return 12;
    case '2 years':
      return 24;
    case '3 years':
      return 36;
    default:
      throw ArgumentError('Invalid time period: $timePeriod');
  }
}
