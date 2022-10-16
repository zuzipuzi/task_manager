import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/src/data/storages/dates_storage.dart';
import 'package:task_manager/src/domain/entities/date.dart';
import 'package:task_manager/src/domain/repositories/date_repository.dart';
import 'package:task_manager/src/presentation/features/utils/logger.dart';

@LazySingleton(as: DateRepository)
class DateRepositoryImpl implements DateRepository {
  DateRepositoryImpl(this._datesStorage);

  final DatesStorage _datesStorage;

  final logger = getLogger('DateRepositoryImpl');

  @override
  Future<List<Date>> getAllDates(DateTime firstDate, DateTime lastDate) async {
    final range = DateTimeRange(start: firstDate, end: lastDate);
    final days = List<DateTime>.generate(
      range.duration.inDays,
      (index) => DateTime.utc(
        firstDate.year,
        firstDate.month,
        firstDate.day,
      ).add(Duration(days: index)),
    );
    List<Date> dates = [];
    for (var day in days) {
      final date = _datesStorage.getDate(day);
      if (date != null) {
        dates.add(date);
      } else {
        logger.i(day);
        throw Exception();
      }
    }
    return dates;
  }

  @override
  Date? getDate(DateTime dateTime) {
    final date = _datesStorage.getDate(dateTime);
    return date;
  }

  @override
  Future<void> changeDate(Date date) async {
    await _datesStorage.changeDate(date);
  }
}
