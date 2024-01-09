/*
  {
    "id": 1,
    "name": "John Doe",
    "username": "jhon-doi",
    "email": "jhondoi@gm.co"
  }
 */

import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get username => text()();
  TextColumn get email => text()();
}
