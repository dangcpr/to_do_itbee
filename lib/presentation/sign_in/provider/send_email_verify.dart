import 'package:flutter/material.dart';

import '../../../domain/usecases/auth_usecase.dart';

class SendEmailVerify extends ChangeNotifier {
  final AuthUsecase _authUsecase;

  SendEmailVerify(this._authUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> sendEmailVerify() async {
    setLoading(true);
    setError(''); // Reset error message
    try {
      await _authUsecase.sendEmailVerification();
    } catch (e) {
      setError(e.toString()); // Set error message
    } finally {
      setLoading(false);
    }
  }
}