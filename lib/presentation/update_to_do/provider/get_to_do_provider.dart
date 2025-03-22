import 'package:flutter/material.dart';
import 'package:to_do_itbee/domain/entities/to_do_entity.dart';

import '../../../domain/usecases/to_do_usecase.dart';

class GetToDoProvider extends ChangeNotifier {
  final ToDoUsecase _toDoUsecase;

  GetToDoProvider(this._toDoUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  ToDoEntity? _toDo;
  ToDoEntity? get toDo => _toDo;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> getToDoById(int idToDo) async {
    setLoading(true);
    try {
      _toDo = await _toDoUsecase.getToDoById(idToDo);
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
