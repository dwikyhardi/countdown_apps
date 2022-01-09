class TextConverter {
  TextConverter();

  String call(String? twoDigit) {
    if (twoDigit != null) {
      if (twoDigit.toString().length == 1) {
        return '0' + twoDigit.toString();
      } else {
        return twoDigit.toString();
      }
    } else {
      return '';
    }
  }
}
