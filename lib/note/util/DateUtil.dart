class DateUtil {
  static int dayOfMoth(int year, int month) {
    int day;
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        day = 31;
        break;
      case 4:
      case 6:
      case 9:
      case 11:
        day = 30;
        break;
      case 2:
        {
          if (isSpecialYear(year)) {
            day = 29;
          } else {
            day = 28;
          }
        }
        break;
      default:
        day = -1;
    }
    return day;
  }

  static bool isSpecialYear(int year) {
    bool res;
    if (year % 100 == 0) {
      res = year % 400 == 0;
    } else
      res = year % 4 == 0;

    return res;
  }
}
