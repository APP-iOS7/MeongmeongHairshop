import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: appRoutes, // routes 파일에서 정의한 경로 사용
    );
  }
}
