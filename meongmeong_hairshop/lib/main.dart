import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

import '../views/map_screen.dart';
import '../viewmodels/map_view_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화

  await NaverMapSdk.instance.initialize(
    clientId: 'yd79jdvpdg', // 네이버 지도 API 클라이언트 ID
    onAuthFailed: (ex) => print("********* auth failed $ex ********"),
  );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '애견 미용실 지도',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => MapViewModel(),
        child: MapScreen(),
      ),
    );
  }
}