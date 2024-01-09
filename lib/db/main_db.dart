import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:drift_background_isolate_starter/db/entity/user_db_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

part 'main_db.g.dart';

@DriftDatabase(tables: [Users])
class MainDatabase extends _$MainDatabase {
  MainDatabase() : super(openConnection());

  MainDatabase.connect(DatabaseConnection connection)
      : super.connect(connection);

  @override
  int get schemaVersion => 1;
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    if (kDebugMode) {
      await openDatabase(file.path);
    }
    return NativeDatabase.createInBackground(file, logStatements: true);
  });
}

Future<DriftIsolate> backgroundConnectionIsolate() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'db.sqlite');
  debugPrint('db path $path');
  final database = NativeDatabase(File(path));
  DriftIsolate isolate =
      DriftIsolate.inCurrent(() => DatabaseConnection(database));
  return isolate;
}
