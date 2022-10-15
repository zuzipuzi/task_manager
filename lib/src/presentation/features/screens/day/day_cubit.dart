import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/src/domain/entities/date.dart';
import 'package:task_manager/src/domain/entities/task.dart';
import 'package:task_manager/src/domain/repositories/date_repository.dart';
import 'package:task_manager/src/presentation/features/utils/logger.dart';

part 'day_state.dart';

@Injectable()
class DayCubit extends Cubit<DayState> {
  DayCubit(this._dateRepository) : super(const DayState());

  final DateRepository _dateRepository;

  final logger = getLogger('DayCubit');

  void getDate(Date date) {
    emit(state.copyWith(
        currentDate: date, task: state.task.copyWith(time: date.dateTime)));
  }

  void onTitleChanged(String title) {
    emit(state.copyWith(task: state.task.copyWith(title: title)));
  }

  void onDescriptionChanged(String description) {
    emit(state.copyWith(task: state.task.copyWith(description: description)));
  }

  void onTimeChanged(DateTime time) {
    emit(state.copyWith(task: state.task.copyWith(time: time)));
  }

  void addTask() {
    List<Task> tasks = List.from(state.currentDate.tasks);
    tasks.add(state.task.copyWith(
        title: state.task.title,
        description: state.task.description,
        time: state.task.time));
    _dateRepository.changeDate(state.currentDate.copyWith(tasks: tasks));
    emit(state.copyWith(currentDate: state.currentDate.copyWith(tasks: tasks)));
  }

  void removeTask(int index) {
    List<Task> tasks = List.from(state.currentDate.tasks)..removeAt(index);
    _dateRepository.changeDate(state.currentDate.copyWith(tasks: tasks));
    emit(state.copyWith(currentDate: state.currentDate.copyWith(tasks: tasks)));
  }
}
