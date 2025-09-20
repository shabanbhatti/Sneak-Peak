 import 'package:intl/intl.dart';

String dateFormat(String date) {
    DateTime parsedDate = DateTime.parse(date);
    var format = DateFormat('dd/MM/yyyy').format(parsedDate);

    return format;
  }