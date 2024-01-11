import 'dart:isolate';

import 'package:drift_background_isolate_starter/isolate/isolate_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry-point')
Future<void> isolateEntryPoint(List<Object> args) async {
  final SendPort sendPort = args[0] as SendPort;
  final RootIsolateToken token = args[1] as RootIsolateToken;
  final apiID = args[2] as int;
  try {
    debugPrint('inside isolateEntryPoint $apiID');

    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    // Make the network call
    final users = await getUsersFromApi(apiID);

    //do a heavy task
    for (var i = 0; i < 1200000000; i++) {}

    debugPrint('users $users');
    if (users == null) {
      sendPort.send(null);
    } else {
      //insert user
      final response = await insertUserToDB(users);
      debugPrint('response $response');
      if (response) {
        sendPort.send(users);
      } else {
        sendPort.send(null);
      }
    }
    sendPort.send('done');
  }
  // Catch any errors thrown during the network call
  catch (e) {
    sendPort.send(null);
  }
}
