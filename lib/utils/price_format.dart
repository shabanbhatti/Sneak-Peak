import 'package:intl/intl.dart';

String priceFormat(int number) {
    var format = NumberFormat('#,###');
    return format.format(number);
  }