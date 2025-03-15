import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'platform_stub.dart' if (dart.library.io) 'platform_io.dart';

import 'memora_home.dart';

void main() async {
  print('Platform version: ${getPlatformVersion()}');
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "your_api_key",
      authDomain: "your_project_id.firebaseapp.com",
      projectId: "your_project_id",
      storageBucket: "your_project_id.appspot.com",
      messagingSenderId: "your_messaging_sender_id",
      appId: "your_app_id",
    ),
  );
  runApp(const MemoraApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL; // Set the logging level
  Logger.root.onRecord.listen((record) {
    print('[TEST] ${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MemoraApp extends StatelessWidget {
  const MemoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEMORA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const MemoraHomePage(title: 'MEMORA'),
    );
  }
}
