import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/firebase_service.dart';
import '../../models/user_model.dart';

abstract interface class AuthRemoteData {
  Future<UserModel> login(String email, String password);
  Future<void> register(String email, String password);
  UserModel autoLogin();
  Future<void> logout();
  Future<void> resetPassword(String oldPassword, String newPassword);
  Future<void> sendForgotPasswordEmail(String email);
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}

class AuthRemoteDataImpl implements AuthRemoteData {
  final FirebaseService _firebaseService;

  AuthRemoteDataImpl(this._firebaseService);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user == null) {
        throw 'User not found';
      }
      if (!user.emailVerified) {
        await _firebaseService.auth.signOut();
        throw 'Email not verified';
      }
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        avatar: user.photoURL ?? '',
      );
      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'User not found';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password';
      } else {
        throw 'Error: ${e.message}';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        throw 'User not logged in';
      }
      await currentUser.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification();
      await logout();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'Email already in use';
      } else {
        throw 'Error: ${e.message}';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  UserModel autoLogin() {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        throw 'User not logged in';
      }
      final userModel = UserModel(
        id: currentUser.uid,
        email: currentUser.email ?? '',
        avatar: currentUser.photoURL ?? '',
      );
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        throw 'User not logged in';
      }
      return currentUser.emailVerified;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseService.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String oldPassword, String newPassword) async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        throw 'User not logged in';
      }
      await currentUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: currentUser.email ?? '',
          password: oldPassword,
        ),
      );
      return currentUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'User not found';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password';
      } else {
        throw 'Error: ${e.message}';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendForgotPasswordEmail(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
