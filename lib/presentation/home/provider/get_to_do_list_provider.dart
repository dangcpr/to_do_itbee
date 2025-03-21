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
  String? _searchPatternCurrent;

  List<ToDoEntity> get toDoList => _toDoList;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Status? get status => _statusCurrent;

  String? get searchPattern => _searchPatternCurrent;

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

  void setSearchPattern(String? value) {
    _searchPatternCurrent = value;
    notifyListeners();
  }

  Future<void> getToDoList({Status? status, String? searchPattern}) async {
    setLoading(true);
    setStatus(status);
    setSearchPattern(searchPattern);
    try {
      _toDoList = await _toDoUsecase.getToDoList(
        status: status,
        searchPattern: searchPattern,
      );
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  Future<void> getToDoListStatusSearchCurrent() async {
    setLoading(true);
    try {
      _toDoList = await _toDoUsecase.getToDoList(
        status: _statusCurrent,
        searchPattern: _searchPatternCurrent,
      );
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  Future<void> getToDoNotLoading() async {
    try {
      _toDoList = await _toDoUsecase.getToDoList(
        status: _statusCurrent,
        searchPattern: _searchPatternCurrent,
      );
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    }
  }
}
