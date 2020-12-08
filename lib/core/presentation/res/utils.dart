DateTime beginingOfDay(date) => DateTime(date.year,date.month,date.day,0,0,0);
DateTime endOfDay(date) => DateTime(date.year,date.month,date.day,23,59,59);
DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }