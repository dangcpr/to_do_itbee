
import '../../core/const.dart';
import '../../domain/entities/to_do_entity.dart';
import '../models/to_do_model.dart';

abstract interface class ToDoData {
  Future<List<ToDoModel>> getToDoList({Status status = Status.all, String? searchPattern});
  Future<ToDoModel> getToDoById(int idToDo);
  Future<void> createToDo(ToDoEntity toDo);
  Future<void> updateToDo(ToDoEntity toDo);
  Future<void> updateStatus(int idToDo, Status status);
  Future<void> deleteToDo(int idToDo);
}