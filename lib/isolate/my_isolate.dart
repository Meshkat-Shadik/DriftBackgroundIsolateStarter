import 'dart:isolate';

import 'package:drift_background_isolate_starter/isolate/isolate_entries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MyIsolate {
  @pragma('vm:entry-point')
  static Future<void> start(
    Future<void> Function() closure,
    SendPort uiSendport,
  ) async {
    final receivePort = ReceivePort();
    await Isolate.run(closure);
    receivePort.listen((message) {
      debugPrint('message $message');
      if (message == 'done') {
        debugPrint('done');
        receivePort.close();
        uiSendport.send('done');
      }
    });
  }

  // Closure that includes your isolate entry point and its arguments
  @pragma('vm:entry-point')
  static Future<void> Function() createIsolateFunction(
      SendPort sendPort, RootIsolateToken token, int apiID) {
    return () async {
      debugPrint('inside createIsolateFunction $apiID');
      await isolateEntryPoint([sendPort, token, apiID]);
    };
  }
}
