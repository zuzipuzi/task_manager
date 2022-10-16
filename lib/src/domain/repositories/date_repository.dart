import 'package:task_manager/src/domain/entities/date.dart';

abstract class DateRepository {
  Date? getDate(DateTime date);

  Future<List<Date>> getAllDates(DateTime firstDate, DateTime lastDate);

  Future<void> changeDate(Date date);
}
