class ToDoEntity {
  int? id;
  String title;
  String description;
  int status; // 0 - Chưa hoàn thành, 1 - Hoàn thành
  DateTime dueDate;
  DateTime createdAt;
  DateTime updatedAt;

  ToDoEntity({
    this.id,
    required this.title,
    required this.description,
    this.status = 0,
    required this.dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc(),
       updatedAt = updatedAt ?? DateTime.now().toUtc();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'due_date': dueDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
