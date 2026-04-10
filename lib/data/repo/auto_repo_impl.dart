import '../../data/data_source/remote/auth_remote.dart';
import '../../domain/repo/auth_repo.dart';
import '../models/user_model.dart';

class AutoRepoImpl implements AuthRepo {
  final AuthRemoteData _authRemoteData;

  AutoRepoImpl(this._authRemoteData);
  @override
  Future<UserModel> login(String email, String password) =>
      _authRemoteData.login(email, password);

  @override
  Future<void> register(String email, String password) =>
      _authRemoteData.register(email, password);

  @override
  UserModel autoLogin() => _authRemoteData.autoLogin();

  @override
  Future<void> logout() => _authRemoteData.logout();
  
  @override
  Future<void> resetPassword(String oldPassword, String newPassword) =>
      _authRemoteData.resetPassword(oldPassword, newPassword);

  @override
  Future<void> sendForgotPasswordEmail(String email) =>
      _authRemoteData.sendForgotPasswordEmail(email);
  
  @override
  Future<void> sendEmailVerification() =>
      _authRemoteData.sendEmailVerification();
  
  @override
  Future<bool> isEmailVerified() => _authRemoteData.isEmailVerified();
}
