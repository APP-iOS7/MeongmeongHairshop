import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import 'providers/map_provider.dart';
import 'views/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: 'yd79jdvpdg', // 네이버 지도 API 클라이언트 ID
    onAuthFailed: (ex) => print("********* auth failed $ex ********"),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapProvider()..initialize(), // 초기화 시 현재 위치 가져오기 등
      child: MaterialApp(
        title: '애견 미용실 지도',
        theme: ThemeData(),
        home: MapScreen(),
      ),
    );
  }
}
