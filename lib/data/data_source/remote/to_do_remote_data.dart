import 'package:to_do_itbee/core/const.dart';

import 'package:to_do_itbee/data/models/to_do_model.dart';

import 'package:to_do_itbee/domain/entities/to_do_entity.dart';

import '../../../services/firebase_service.dart';
import '../to_do_data_base.dart';

class ToDoRemoteDataImpl implements ToDoData {
  final FirebaseService _firebaseService;

  late final String uid;

  ToDoRemoteDataImpl(this._firebaseService) {
    uid = _firebaseService.auth.currentUser!.uid;
  }

  @override
  Future<void> createToDo(ToDoEntity toDo) {
    // TODO: implement createToDo
    throw UnimplementedError();
  }

  @override
  Future<void> deleteToDo(int idToDo) {
    // TODO: implement deleteToDo
    throw UnimplementedError();
  }

  @override
  Future<ToDoModel> getToDoById(int idToDo) {
    // TODO: implement getToDoById
    throw UnimplementedError();
  }

  @override
  Future<List<ToDoModel>> getToDoList({Status? status, String? searchPattern}) {
    // TODO: implement getToDoList
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus(int idToDo, Status status) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }

  @override
  Future<void> updateToDo(ToDoEntity toDo) {
    // TODO: implement updateToDo
    throw UnimplementedError();
  }
}