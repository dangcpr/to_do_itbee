import '../entities/user_entity.dart';
import '../repo/auth_repo.dart';

class AuthUsecase {
  final AuthRepo _authRepo;

  AuthUsecase(this._authRepo);

  Future<UserEntity> login(String email, String password) =>
      _authRepo.login(email, password);
  Future<void> register(String email, String password) =>
      _authRepo.register(email, password);
  UserEntity autoLogin() => _authRepo.autoLogin();
  Future<void> logout() => _authRepo.logout();
  Future<void> resetPassword(String oldPassword, String newPassword) =>
      _authRepo.resetPassword(oldPassword, newPassword);
  Future<void> sendForgotPasswordEmail(String email) => 
      _authRepo.sendForgotPasswordEmail(email);
  Future<void> sendEmailVerification() => _authRepo.sendEmailVerification();
  Future<bool> isEmailVerified() => _authRepo.isEmailVerified();
}
