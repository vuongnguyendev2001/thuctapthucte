import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// MARK: - Initials;
  static String convertPrice({required num price}) {
    return NumberFormat.simpleCurrency(locale: 'vi-VN').format(price);
  }

  static String numFormat({required num number}) {
    return NumberFormat(null, 'vi').format(number).replaceAll('.', ',');
  }
    String formattedDate(timeStamp) {
    var dateFormTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy').format(dateFormTimeStamp);
  }

  String formattedDatebook(timeStamp) {
    var dateFormTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateFormTimeStamp);
  }
}
