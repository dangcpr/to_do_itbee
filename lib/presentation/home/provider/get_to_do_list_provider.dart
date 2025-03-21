import 'package:flutter/material.dart';

import '../../../core/const.dart';
import '../../../domain/entities/to_do_entity.dart';
import '../../../domain/usecases/to_do_usecase.dart';

class GetToDoListProvider extends ChangeNotifier {
  final ToDoUsecase _toDoUsecase;

  GetToDoListProvider(this._toDoUsecase);

  bool _isLoading = false;
  String _errorMessage = '';
  List<ToDoEntity> _toDoList = [];
  Status? _statusCurrent = Status.all;

  List<ToDoEntity> get toDoList => _toDoList;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Status? get status => _statusCurrent;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  void setStatus(Status? value) {
    _statusCurrent = value;
    notifyListeners();
  }

  Future<void> getToDoList({Status? status}) async {
    setLoading(true);
    setStatus(status);
    try {
      _toDoList = await _toDoUsecase.getToDoList(status: status);
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  Future<void> getToDoListWithCurrentStatus() async {
    setLoading(true);
    try {
      _toDoList = await _toDoUsecase.getToDoList(status: _statusCurrent);
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }
}
