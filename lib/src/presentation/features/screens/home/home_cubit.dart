import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/src/domain/entities/date.dart';
import 'package:task_manager/src/domain/repositories/date_repository.dart';
import 'package:task_manager/src/presentation/features/utils/logger.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._dateRepository) : super(const HomeState());
  final DateRepository _dateRepository;

  final logger = getLogger('HomeCubit');

  Future<void> initParams() async {
    emit(state.copyWith(
        firstDate: DateTime(2018, 01, 01),
        lastDate: DateTime(2024, 01, 01),
        initialDate: DateTime.now(),
        loading: true));

    final isFirstDateExist = _dateRepository.getDate(state.firstDate!) != null;
    if (isFirstDateExist) {
      final dates =
          await _dateRepository.getAllDates(state.firstDate!, state.lastDate!);
      setDates(dates);
    } else {
      generateCalendar();
    }
    emit(state.copyWith(loading: false));
  }

  void generateCalendar() {
    final range = DateTimeRange(start: state.firstDate!, end: state.lastDate!);

    final dates = List<DateTime>.generate(
      range.duration.inDays,
      (index) => DateTime.utc(
        state.firstDate!.year,
        state.firstDate!.month,
        state.firstDate!.day,
      ).add(Duration(days: index)),
    );

    List<List<Date>> months = [];

    for (var date in dates) {
      final dateEntity = mockedDate.copyWith(dateTime: date);
      if (months.isNotEmpty && months.last.last.dateTime!.month == date.month) {
        months.last.add(dateEntity);
      } else {
        months.add([dateEntity]);
        if (months.last.last.dateTime!.month == state.initialDate!.month &&
            months.last.last.dateTime!.year == state.initialDate!.year) {
          emit(state.copyWith(currentMonthIndex: months.indexOf(months.last)));
        }
      }
      _dateRepository.changeDate(dateEntity);
    }
    _dateRepository.getDate(state.initialDate!);
    emit(state.copyWith(months: months));
  }

  void setDates(List<Date> dates) {
    List<List<Date>> months = [];

    for (var date in dates) {
      if (months.isNotEmpty &&
          months.last.last.dateTime!.month == date.dateTime!.month) {
        months.last.add(date);
      } else {
        months.add([date]);
        if (months.last.last.dateTime!.month == state.initialDate!.month &&
            months.last.last.dateTime!.year == state.initialDate!.year) {
          emit(state.copyWith(currentMonthIndex: months.indexOf(months.last)));
        }
      }
    }
    _dateRepository.getDate(state.initialDate!);
    emit(state.copyWith(months: months));
  }

  void getCurrentMonth(int monthIndex) {
    List<Date> currentMonth = state.months.elementAt(monthIndex);

    final lastMonth =
        state.months.elementAt(monthIndex != 0 ? monthIndex - 1 : 0);

    final nextMonth = state.months.elementAt(
        monthIndex != state.months.length - 1 ? monthIndex + 1 : monthIndex);

    int firstDatesIndex = 0;
    while (currentMonth.first.dateTime!.weekday != 1) {
      currentMonth = List.from(currentMonth)
        ..insert(
            0, lastMonth[lastMonth.indexOf(lastMonth.last) - firstDatesIndex]);
      firstDatesIndex += 1;
    }

    int lastDatesIndex = 0;
    while (currentMonth.last.dateTime!.weekday != 7) {
      currentMonth = List.from(currentMonth)
        ..add(nextMonth[nextMonth.indexOf(nextMonth.first) + lastDatesIndex]);
      lastDatesIndex += 1;
    }
    emit(state.copyWith(currentMonth: currentMonth));
    onPageChanged(monthIndex);
  }

  void onPageChanged(int index) {
    emit(state.copyWith(currentMonthIndex: index));
  }
}
