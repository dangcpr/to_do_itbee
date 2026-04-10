import '../../core/const.dart';
import '../../domain/entities/to_do_entity.dart';
import '../../domain/repo/to_do_repo.dart';
import '../data_source/to_do_data_base.dart';
import '../models/to_do_model.dart';

class ToDoRepoImpl implements ToDoRepo {
  final ToDoData _toDoLocalData;

  ToDoRepoImpl(this._toDoLocalData);

  @override
  Future<List<ToDoModel>> getToDoList({
    Status status = Status.all,
    String? searchPattern,
  }) =>
      _toDoLocalData.getToDoList(status: status, searchPattern: searchPattern);

  @override
  Future<ToDoModel> getToDoById(int idToDo) => _toDoLocalData.getToDoById(idToDo);

  @override
  Future<void> createToDo(ToDoEntity toDo) => _toDoLocalData.createToDo(toDo);

  @override
  Future<void> updateToDo(ToDoEntity toDo) => _toDoLocalData.updateToDo(toDo);

  @override
  Future<void> updateStatus(int idToDo, Status status) =>
      _toDoLocalData.updateStatus(idToDo, status);

  @override
  Future<void> deleteToDo(int idToDo) => _toDoLocalData.deleteToDo(idToDo);
}
