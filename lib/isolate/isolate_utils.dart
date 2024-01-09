//dio call function that returns parsed data
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift_background_isolate_starter/db/dao/user_db_dao.dart';
import 'package:drift_background_isolate_starter/db/main_db.dart';
import 'package:drift_background_isolate_starter/model/user_dto.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<UserDto?> getUsersFromApi(int id) async {
  final dio = Dio();
  final response =
      await dio.get('https://jsonplaceholder.typicode.com/users/$id');
  if (response.statusCode == 200) {
    return UserDto.fromJson(response.data);
  } else {
    return null;
  }
}

//databse call
@pragma('vm:entry-point')
Future<bool> insertUserToDB(UserDto user) async {
  try {
    DriftIsolate isolate;
    DatabaseConnection connection = DatabaseConnection.delayed(() async {
      isolate = await backgroundConnectionIsolate();
      return await isolate.connect();
    }());
    MainDatabase db = MainDatabase.connect(connection);
    UsersDAO dao = UsersDAO(db);
    final response = await dao.insertUser(user);
    debugPrint('response $response');
    await connection.executor.close();
    db.close();
    return response;
  } catch (e) {
    return false;
  }
}
