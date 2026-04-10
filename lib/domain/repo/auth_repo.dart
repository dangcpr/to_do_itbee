import '../entities/user_entity.dart';

abstract interface class AuthRepo {
  Future<UserEntity> login(String email, String password);
  Future<void> register(String email, String password);
  UserEntity autoLogin();
  Future<void> logout();
  Future<void> resetPassword(String oldPassword, String newPassword);
  Future<void> sendForgotPasswordEmail(String email);
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}
