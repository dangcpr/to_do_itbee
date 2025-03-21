import '../../core/const.dart';
import '../entities/to_do_entity.dart';

abstract interface class ToDoRepo {
  Future<List<ToDoEntity>> getToDoList({Status? status, String? searchPattern});
  Future<void> createToDo(ToDoEntity toDo);
  Future<void> updateToDo(ToDoEntity toDo);
  Future<void> updateStatus(int idToDo, Status status);
  Future<void> deleteToDo(int idToDo);
}
