import '../../../core/const.dart';
import '../../../core/database.dart';
import '../../../domain/entities/to_do_entity.dart';
import '../../models/to_do_model.dart';
import '../base_data_source.dart';

abstract interface class ToDoLocalData {
  Future<List<ToDoModel>> getToDoList({Status? status});
  Future<void> createToDo(ToDoEntity toDo);
  Future<void> updateToDo(ToDoEntity toDo);
  Future<void> updateStatus(int idToDo, Status status);
  Future<void> deleteToDo(int idToDo);
}

class ToDoLocalDataImpl extends BaseDataSource implements ToDoLocalData {
  final AppDatabase _appDatabase;
  ToDoLocalDataImpl(this._appDatabase);
  @override
  Future<void> createToDo(ToDoEntity toDo) async {
    try {
      final toDoJson = toDo.toMap();
      await _appDatabase.db.insert(NameEntity.tasks, toDoJson);
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ToDoModel>> getToDoList({Status? status}) async {
    try {
      final result =
          (status == Status.all || status == null)
              ? await _appDatabase.db.query(NameEntity.tasks)
              : await _appDatabase.db.query(
                NameEntity.tasks,
                where: 'status = ?',
                whereArgs: [status.index],
              );
      return result.map((e) => ToDoModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateToDo(ToDoEntity toDo) async {
    try {
      final toDoJson = ToDoEntity(
        id: toDo.id,
        title: toDo.title,
        description: toDo.description,
        status: toDo.status,
        dueDate: toDo.dueDate,
        updatedAt: DateTime.now(),
      ).toMap();

      await _appDatabase.db.update(
        NameEntity.tasks,
        toDoJson,
        where: 'id = ?',
        whereArgs: [toDo.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateStatus(int idToDo, Status status) async {
    try {
      await _appDatabase.db.update(
        NameEntity.tasks,
        {'status': status.index},
        where: 'id = ?',
        whereArgs: [idToDo],
      );
    } catch (e) {
      rethrow;
    }
  }
}
