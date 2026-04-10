import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({super.id, super.email, super.password, super.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    password: json['password'],
    avatar: json['avatar'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'avatar': avatar,
  };
}
