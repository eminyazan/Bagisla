import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String humanReadableDate(DateTime date) {
  initializeDateFormatting('tr', null).then((_) async {});
  return DateFormat.yMMMMEEEEd('tr').format(date).toString();
}
String humanReadableTime(DateTime date) {
  initializeDateFormatting('tr', null).then((_) async {});
  return DateFormat.Hm('tr').format(date).toString();
}
