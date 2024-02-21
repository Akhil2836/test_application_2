import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_application_2/views/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCvvPZf3_LVrucZjfREThQDQC_TOJGJfCc",
            appId: "1:928984358544:web:9d6df577f11dffa3b54215",
            messagingSenderId: "928984358544",
            projectId: "testriver-c7095",
            storageBucket: "testriver-c7095.appspot.com"));
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCvvPZf3_LVrucZjfREThQDQC_TOJGJfCc",
            appId: "1:928984358544:android:9d6df577f11dffa3b54215",
            messagingSenderId: "928984358544",
            projectId: "testriver-c7095",
            storageBucket: "testriver-c7095.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
