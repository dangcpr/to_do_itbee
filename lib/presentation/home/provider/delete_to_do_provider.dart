import 'package:flutter/material.dart';

import '../../../domain/usecases/to_do_usecase.dart';

class DeleteToDoProvider extends ChangeNotifier {
  final ToDoUsecase _toDoUsecase;

  DeleteToDoProvider(this._toDoUsecase);

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> deleteToDo(int idToDo) async {
    setLoading(true);
    try {
      await _toDoUsecase.deleteToDo(idToDo);
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }
}