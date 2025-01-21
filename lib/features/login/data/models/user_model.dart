import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.username, required super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json['username'], token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'token': token,
    };
  }
}
