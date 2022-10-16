import 'package:equatable/equatable.dart';
import 'package:task_manager/src/domain/entities/task.dart';

const mockedDate = Date(
  dateTime: null,
  tasks: [],
);

class Date extends Equatable {
  const Date({
    required this.dateTime,
    required this.tasks,
  });

  final DateTime? dateTime;
  final List<Task> tasks;

  Date copyWith({
    DateTime? dateTime,
    List<Task>? tasks,
  }) {
    return Date(
      dateTime: dateTime ?? this.dateTime,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [
        dateTime,
        tasks,
      ];

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime?.toIso8601String(),
      'task': tasks.map((e) => e.toMap()).toList(),
    };
  }

  factory Date.fromMap(Map<String, dynamic> map) {
    final taskMaps = map['task'] as List<dynamic>;
    List<Task> tasks = [];
    for (var task in taskMaps) {
      tasks.add(Task.fromMap(task));
    }
    return Date(
      dateTime: DateTime.parse(map['dateTime']),
      tasks: tasks,
    );
  }
}
