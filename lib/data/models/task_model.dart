import 'package:taski/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String title,
    required String description,
    required DateTime createdAt,
    bool isCompleted = false,
  }) : super(
          id: id,
          title: title,
          description: description,
          createdAt: createdAt,
          isCompleted: isCompleted,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isCompleted: json['is_completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }
} 