import 'package:drift/drift.dart';
import 'package:drift_background_isolate_starter/db/entity/user_db_entity.dart';
import 'package:drift_background_isolate_starter/db/main_db.dart';
import 'package:drift_background_isolate_starter/model/user_dto.dart';
import 'package:flutter/foundation.dart';

part 'user_db_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDAO extends DatabaseAccessor<MainDatabase> with _$UsersDAOMixin {
  UsersDAO(MainDatabase db) : super(db);

  Future<List<User>> getAllUsers() => select(users).get();

  //watch all usersDto
  Stream<List<UserDto>> watchAllUsers() {
    return (select(users)).watch().map((rows) {
      return rows
          .map((row) => UserDto.fromDBEntity(row.toCompanion(false)))
          .toList();
    });
  }

  //insert user from dto
  Future<bool> insertUser(UserDto user) async {
    try {
      final response = await into(users)
          .insert(user.toDBEntity(), mode: InsertMode.insertOrReplace);
      debugPrint('response $response');
      return response > 0;
    } catch (e) {
      return false;
    }
  }

  //add a new user from dto
  Future<bool> addUser(UserDto user) async {
    try {
      final response = await into(users).insert(user.toDBEntity());
      debugPrint('response $response');
      return true;
    } catch (e) {
      return false;
    }
  }

  //delete user by id
  Future<bool> deleteUser(int id) async {
    try {
      final response =
          await (delete(users)..where((u) => u.id.equals(id))).go();
      debugPrint('response $response');
      return true;
    } catch (e) {
      return false;
    }
  }
}
