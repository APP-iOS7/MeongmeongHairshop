import 'package:flutter/material.dart';
import 'package:meongmeong_hairshop/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main()  async {
  // 날짜 한글화
  await initializeDateFormatting();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/services',
      routes: appRoutes, // routes 파일에서 정의한 경로 사용
    );
  }
}
