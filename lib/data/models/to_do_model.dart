import 'package:to_do_itbee/domain/entities/to_do_entity.dart';

class ToDoModel extends ToDoEntity {
  ToDoModel({
    super.id,
    required super.title,
    required super.description,
    super.status = 0,
    required super.dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    status: json['status'],
    dueDate: DateTime.parse(json['due_date']),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'due_date': dueDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
