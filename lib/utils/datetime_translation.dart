const monthAbbreviations = {
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

const monthNames = {
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
        '${monthAbbreviations[dateTime.month]} $dayZeroOrNothing${dateTime.day}';
  }
  var yearInfix = (dateTime.year > today.year) ? ' ${dateTime.year},' : '';

  return '$prefix,$yearInfix $hourZeroOrNothing${dateTime.hour}:$minuteZeroOrNothing${dateTime.minute}';
}

String reminderNotificationDateText(DateTime dateTime) {
  String dayZeroOrNothing = (dateTime.day < 10) ? '0' : '';
  String hourZeroOrNothing = (dateTime.hour < 10) ? '0' : '';
  String minuteZeroOrNothing = (dateTime.minute < 10) ? '0' : '';
  var month = monthAbbreviations[dateTime.month];
  var day = '$dayZeroOrNothing${dateTime.day}';
  var hour = '$hourZeroOrNothing${dateTime.hour}';
  var min = '$minuteZeroOrNothing${dateTime.minute}';

  return '$month $day, $hour:$min';
}
