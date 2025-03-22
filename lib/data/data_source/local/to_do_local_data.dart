import '../../../core/const.dart';
import '../../../core/database.dart';
import '../../../domain/entities/to_do_entity.dart';
import '../../../services/notification_service.dart';
import '../../models/to_do_model.dart';
import '../base_data_source.dart';

abstract interface class ToDoLocalData {
  Future<List<ToDoModel>> getToDoList({Status? status, String? searchPattern});
  Future<void> createToDo(ToDoEntity toDo);
  Future<void> updateToDo(ToDoEntity toDo);
  Future<void> updateStatus(int idToDo, Status status);
  Future<void> deleteToDo(int idToDo);
}

class ToDoLocalDataImpl extends BaseDataSource implements ToDoLocalData {
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
    Status? status,
    String? searchPattern,
  }) async {
    try {
      final result = await _appDatabase.db.query(
        NameEntity.tasks,
        where:
            'status = COALESCE(?, status) and (title LIKE ? or description LIKE ?)',
        whereArgs: [
          status == Status.all ? null : status?.index,
          '%${searchPattern ?? ''}%',
          '%${searchPattern ?? ''}%',
        ],
      );
      return result.map((e) => ToDoModel.fromJson(e)).toList();
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
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [idToDo],
      );
    } catch (e) {
      rethrow;
    }
  }
}
