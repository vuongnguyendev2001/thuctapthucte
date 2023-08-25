import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// MARK: - Initials;
  static String convertPrice({required num price}) {
    return NumberFormat.simpleCurrency(locale: 'vi-VN').format(price);
  }

  static String numFormat({required num number}) {
    return NumberFormat(null, 'vi').format(number).replaceAll('.', ',');
  }
}
