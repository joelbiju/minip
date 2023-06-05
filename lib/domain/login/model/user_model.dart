import 'dart:convert';

class UserModel {
  static final UserModel instance = UserModel._internal();
  factory UserModel() => instance;
  UserModel._internal();

  late String email;
  late String username;
  late String userId;

  UserModel getValues({
    required String email,
    required String username,
    required String userId,
  }) {
    this.email = email;
    this.username = username;
    this.userId = userId;
    return this;
  }

  factory UserModel.fromJson(String jsonString) {
    Map<String, dynamic> data = jsonDecode(jsonString);
    return UserModel.instance.getValues(
      email: data['email'],
      username: data['username'],
      userId: data['userId'],
    );
  }

  String toJson() =>
      '''{"email": "$email","username": "$username","userId": "$userId"}''';
}
