import 'package:drift/drift.dart';
import 'package:drift_background_isolate_starter/db/main_db.dart';

class UserDto {
  final int? id;
  final String? name;
  final String? username;
  final String? email;

  UserDto({
    this.id,
    this.name,
    this.username,
    this.email,
  });

  UserDto copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
  }) =>
      UserDto(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        email: email ?? this.email,
      );

  @override
  String toString() {
    return 'UserDto(id: $id, name: $name, username: $username, email: $email)';
  }

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as int?,
        name: json['name'] as String?,
        username: json['username'] as String?,
        email: json['email'] as String?,
      );

  factory UserDto.fromDBEntity(UsersCompanion user) {
    return UserDto(
      id: user.id.value,
      name: user.name.value,
      username: user.username.value,
      email: user.email.value,
    );
  }

  UsersCompanion toDBEntity() {
    return UsersCompanion(
      id: Value(id!),
      name: Value(name!),
      username: Value(username!),
      email: Value(email!),
    );
  }
}
