import 'package:flutter/material.dart';

import '../../../core/const.dart';
import '../../../domain/usecases/to_do_usecase.dart';

class UpdateToDoStatusProvider extends ChangeNotifier {
  final ToDoUsecase _toDoUsecase;

  UpdateToDoStatusProvider(this._toDoUsecase);

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

  Future<void> update(int idToDo, Status status) async {
    setLoading(true);
    try {
      await _toDoUsecase.updateStatus(idToDo, status);
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }
}