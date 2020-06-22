const _monthAbbreviations = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

const _monthNames = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

String translateLastEdited(DateTime lastEdited) {
  var now = DateTime.now();
  var dayToday = now.day;
  var monthToday = now.month;
  var yearToday = now.year;
  var yesterday = now.subtract(Duration(days: 1));

  String hourZeroOrNothing = (lastEdited.hour < 10) ? '0' : '';
  String minuteZeroOrNothing = (lastEdited.minute < 10) ? '0' : '';

  // if it is today... Edited 16:53

  if ((lastEdited.day == dayToday) &&
      (lastEdited.month == monthToday) &&
      (lastEdited.year == yearToday)) {
    return 'Edited $hourZeroOrNothing${lastEdited.hour}:$minuteZeroOrNothing${lastEdited.minute}';
  }

  if ((lastEdited.day == yesterday.day) &&
      (lastEdited.month == yesterday.month) &&
      (lastEdited.year == yesterday.year)) {
    return 'Edited Yesterday, $hourZeroOrNothing${lastEdited.hour}:$minuteZeroOrNothing${lastEdited.minute}';
  }

  return 'Edited ${_monthAbbreviations[lastEdited.month]} ${lastEdited.day}';
}

String translateReminderDay(DateTime dateTimeOfDay) {
  String zeroOrNothing = (dateTimeOfDay.day < 10) ? '0' : '';

  return '${_monthNames[dateTimeOfDay.month]} $zeroOrNothing${dateTimeOfDay.day}';
}

String translateReminderTime(DateTime dateTime) {
  String hourZeroOrNothing = (dateTime.hour < 10) ? '0' : '';
  String minuteZeroOrNothing = (dateTime.minute < 10) ? '0' : '';

  return '$hourZeroOrNothing${dateTime.hour}:$minuteZeroOrNothing${dateTime.minute}';
}

String chipReminderText(DateTime dateTime) {
  var today = DateTime.now();
  var tomorrow = today.add(Duration(days: 1));
  String hourZeroOrNothing = (dateTime.hour < 10) ? '0' : '';
  String minuteZeroOrNothing = (dateTime.minute < 10) ? '0' : '';

  String prefix;

  if ((dateTime.day == today.day) &&
      (dateTime.month == today.month) &&
      (dateTime.year == today.year)) {
    prefix = 'Today';
  } else if ((dateTime.day == tomorrow.day) &&
      (dateTime.month == tomorrow.month) &&
      (dateTime.year == tomorrow.year)) {
    prefix = 'Tomorrow';
  } else {
    String dayZeroOrNothing = (dateTime.day < 10) ? '0' : '';
    prefix =
        '${_monthAbbreviations[dateTime.month]} $dayZeroOrNothing${dateTime.day}';
  }

  return '$prefix, $hourZeroOrNothing${dateTime.hour}:$minuteZeroOrNothing${dateTime.minute}';
}
