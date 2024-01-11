import 'dart:isolate';
import 'dart:math';

import 'package:drift_background_isolate_starter/db/dao/user_db_dao.dart';
import 'package:drift_background_isolate_starter/isolate/isolate_utils.dart';
import 'package:drift_background_isolate_starter/isolate/my_isolate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'db/main_db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Drift Background Isolate Starter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UsersDAO dao;
  late ReceivePort receivePort;
  List<User>? users;
  int _counter = 0;

  @override
  initState() {
    super.initState();
    dao = UsersDAO(MainDatabase());
    Future.delayed(Duration.zero, () async {
      await loadUsers();
      await loadCount();
    });
  }

  Future<void> loadUsers() async {
    users = await dao.getAllUsers();
    setState(() {
      users = users;
    });
  }

  //load count
  Future<void> loadCount() async {
    final length = await dao.getAllUsers().then((value) => value.length);
    setState(() {
      _counter = length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Column(
        children: [
          Text(
            'Total Users: $_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Container(
            height: 200,
            color: Colors.amber,
            child: RefreshIndicator(
              onRefresh: () async {
                await loadUsers();
                await loadCount();
              },
              child: ListView.builder(
                itemCount: users?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users?[index].name ?? "NAme"),
                    subtitle: Text(users?[index].email ?? "Email"),
                    trailing: IconButton(
                      onPressed: () async {
                        final response1 =
                            await dao.deleteUser(users?[index].id ?? 0);
                        debugPrint(response1.toString());
                        await loadUsers();
                        await loadCount();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () async {
              //randomID between 1 and 10
              final apiID = 1 + Random().nextInt(10 - 1);
              final user = await getUsersFromApi(apiID);

              //do a heavy task
              for (var i = 0; i < 1200000000; i++) {}

              final response1 = await dao.addUser(user!);
              debugPrint(response1.toString());
              await loadUsers();
              await loadCount();
            },
            tooltip: 'Add User from Main Isolate',
            child: const Icon(Icons.person_add_alt_1),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () async {
              //randomID between 1 and 10
              final apiID = 1 + Random().nextInt(10 - 1);
              receivePort = ReceivePort();
              debugPrint('clicked');

              final closure = MyIsolate.createIsolateFunction(
                receivePort.sendPort,
                RootIsolateToken.instance!,
                apiID,
              );

              await MyIsolate.start(
                closure,
                receivePort.sendPort,
              );
              //receivePort.asBroadcastStream()
              receivePort.asBroadcastStream().listen((message) async {
                debugPrint('message in ui $message');
                if (message == 'done') {
                  //show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Downloaded'),
                    ),
                  );
                  receivePort.close();
                  await loadUsers();
                  await loadCount();
                }
              });
            },
            tooltip: 'Download Background',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
