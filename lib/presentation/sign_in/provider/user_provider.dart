import 'package:flutter/material.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth_usecase.dart';

class UserProvider extends ChangeNotifier {
  final AuthUsecase _authUsecase;

  UserProvider(this._authUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  UserEntity? _userEntity;
  UserEntity? get userEntity => _userEntity;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  void setUserEntity(UserEntity? value) {
    _userEntity = value;
    notifyListeners();
  }

  void init() {
    setLoading(false);
    setError('');
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    setError(''); // Reset error message
    try {
      final user = await _authUsecase.login(email, password);
      setUserEntity(user);
    } catch (e) {
      setError(e.toString()); // Set error message
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);
    setError(''); // Reset error message
    try {
      await _authUsecase.logout();
      setUserEntity(null);
    } catch (e) {
      setError(e.toString()); // Set error message
    } finally {
      setLoading(false);
    }
  }

  void autoLogin() {
    setLoading(true);
    setError(''); // Reset error message
    try {
      setUserEntity(_authUsecase.autoLogin());
    } catch (e) {
      setError(e.toString()); // Set error message
    } finally {
      setLoading(false);
    }
  }
}