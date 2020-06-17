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

String translateLastEdited(DateTime lastEdited) {
  var now = DateTime.now();
  var dayToday = now.day;
  var monthToday = now.month;
  var yearToday = now.year;
  var yesterday = now.subtract(Duration(days: 1));

  // if it is today... Edited 16:53

  if ((lastEdited.day == dayToday) &&
      (lastEdited.month == monthToday) &&
      (lastEdited.year == yearToday)) {
    return 'Edited ${lastEdited.hour}:${lastEdited.minute}';
  }

  if ((lastEdited.day == yesterday.day) &&
      (lastEdited.month == yesterday.month) &&
      (lastEdited.year == yesterday.year)) {
    return 'Edited Yesterday, ${lastEdited.hour}:${lastEdited.minute}';
  }

  return 'Edited ${_monthAbbreviations[lastEdited.month]} ${lastEdited.day}';
}
