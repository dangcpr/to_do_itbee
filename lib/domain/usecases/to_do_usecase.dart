import '../../core/const.dart';
import '../entities/to_do_entity.dart';
import '../repo/to_do_repo.dart';

class ToDoUsecase {
  final ToDoRepo _toDoRepo;

  ToDoUsecase(this._toDoRepo);

  Future<List<ToDoEntity>> getToDoList({Status? status}) =>
      _toDoRepo.getToDoList(status: status);

  Future<void> createToDo(ToDoEntity toDo) => _toDoRepo.createToDo(toDo);

  Future<void> updateToDo(ToDoEntity toDo) => _toDoRepo.updateToDo(toDo);
  Future<void> updateStatus(int idToDo, Status status) => _toDoRepo.updateStatus(idToDo, status);

  Future<void> deleteToDo(int idToDo) => _toDoRepo.deleteToDo(idToDo);
}
