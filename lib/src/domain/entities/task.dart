import 'package:equatable/equatable.dart';

const mockedTask = Task(
  title: '',
  description: '',
  time: null,
);

class Task extends Equatable {
  const Task({
    required this.title,
    required this.description,
    this.time,
  });

  final String title;
  final String description;
  final DateTime? time;

  Task copyWith({
    String? description,
    String? title,
    DateTime? time,
  }) {
    return Task(
      description: description ?? this.description,
      title: title ?? this.title,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [
        description,
        title,
        time,
      ];

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'title': title,
      'time': time!.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      description: map['description'] as String,
      title: map['title'] as String,
      time: DateTime.parse(map['time']),
    );
  }
}
