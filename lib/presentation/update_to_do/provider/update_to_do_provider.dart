import 'package:flutter/material.dart';

import '../../../domain/entities/to_do_entity.dart';
import '../../../domain/usecases/to_do_usecase.dart';

class UpdateToDoProvider extends ChangeNotifier {
  final ToDoUsecase _toDoUsecase;

  UpdateToDoProvider(this._toDoUsecase);

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

  Future<void> updateToDo(ToDoEntity toDo) async {
    setLoading(true);
    
    try {
      await _toDoUsecase.updateToDo(toDo);
    } catch (e) {
      setError(e.toString());
    }

    setLoading(false);
  }
}