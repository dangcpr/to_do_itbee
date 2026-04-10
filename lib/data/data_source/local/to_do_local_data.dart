import 'dart:convert';

import '../../../core/const.dart';
import '../../../core/database.dart';
import '../../../domain/entities/to_do_entity.dart';
import '../../../services/notification_service.dart';
import '../../models/to_do_model.dart';
import '../to_do_data_base.dart';


class ToDoLocalDataImpl implements ToDoData {
  final AppDatabase _appDatabase;
  final NotificationService _notificationService;

  ToDoLocalDataImpl(this._appDatabase, this._notificationService);

  @override
  Future<void> createToDo(ToDoEntity toDo) async {
    try {
      final toDoJson = toDo.toMap();
      final id = await _appDatabase.db.insert(NameEntity.tasks, toDoJson);

      // schedule notification
      await _notificationService.scheduleNotification(
        id,
        body: toDo.title,
        scheduledDate: toDo.dueDate,
        payload: jsonEncode({'type': 'due_dates', 'id': id}),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteToDo(int idToDo) async {
    try {
      await _appDatabase.db.delete(
        NameEntity.tasks,
        where: 'id = ?',
        whereArgs: [idToDo],
      );

      // cancel notification
      await _notificationService.cancelNotification(idToDo);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ToDoModel>> getToDoList({
    Status status = Status.all,
    String? searchPattern,
  }) async {
    try {
      String whereClause = '(title LIKE ? or description LIKE ?)';
      List<String> whereArgs = [
        '%${searchPattern ?? ''}%',
        '%${searchPattern ?? ''}%',
      ];

      if (status != Status.all) {
        whereClause = 'status = ? and $whereClause';
        whereArgs.insert(0, status.index.toString());
      }

      final result = await _appDatabase.db.query(
        NameEntity.tasks,
        where: whereClause,
        whereArgs: whereArgs,
      );
      return result.map((e) => ToDoModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ToDoModel> getToDoById(int idToDo) async {
    try {
      final result = await _appDatabase.db.query(
        NameEntity.tasks,
        where: 'id = ?',
        whereArgs: [idToDo],
      );
      return ToDoModel.fromJson(result.first);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateToDo(ToDoEntity toDo) async {
    try {
      final toDoJson =
          ToDoEntity(
            id: toDo.id,
            title: toDo.title,
            description: toDo.description,
            status: toDo.status,
            dueDate: toDo.dueDate,
            createdAt: toDo.createdAt,
          ).toMap();

      await _appDatabase.db.update(
        NameEntity.tasks,
        toDoJson,
        where: 'id = ?',
        whereArgs: [toDo.id],
      );

      // update notification
      if (toDo.id != null) {
        await _notificationService.scheduleNotification(
          toDo.id!,
          body: toDo.title,
          scheduledDate: toDo.dueDate,
          payload: jsonEncode({'type': 'due_dates', 'id': toDo.id}),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateStatus(int idToDo, Status status) async {
    try {
      await _appDatabase.db.update(
        NameEntity.tasks,
        {
          'status': status.index,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [idToDo],
      );
    } catch (e) {
      rethrow;
    }
  }
}
