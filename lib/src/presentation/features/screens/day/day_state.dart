part of 'day_cubit.dart';

class DayState extends Equatable {
  const DayState({
    this.currentDate = mockedDate,
    this.task = mockedTask,
  });

  final Date currentDate;
  final Task task;

  DayState copyWith({
    Date? currentDate,
    Task? task,
  }) {
    return DayState(
      currentDate: currentDate ?? this.currentDate,
      task: task ?? this.task,
    );
  }

  @override
  List<Object> get props => [
        currentDate,
        task,
      ];
}
